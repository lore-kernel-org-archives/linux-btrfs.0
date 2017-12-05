Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48806 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751112AbdLEUge (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 15:36:34 -0500
From: Nick Terrell <terrelln@fb.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "Martin Steigerwald" <martin@lichtvoll.de>,
        Imran Geriskovan <imran.geriskovan@gmail.com>
Subject: Re: Read before you deploy btrfs + zstd
Date: Tue, 5 Dec 2017 20:36:13 +0000
Message-ID: <85A4AA7E-2435-4171-BD93-1F96954BEE94@fb.com>
References: <20171113225046.GD28899@suse.cz>
 <20171114185331.GJ28899@twin.jikos.cz> <20171115143906.GM28899@twin.jikos.cz>
 <E55ED8F2-8D16-4B58-9EC3-8DE41E7BE5A2@fb.com> <20171121162239.GO3553@suse.cz>
 <5BB834FC-A54C-4448-8D86-1D2F22806096@fb.com> <20171128234937.GG3553@suse.cz>
 <EF0643B4-092E-4D82-BA5B-9B02DFDEACA6@fb.com>
 <20171205155433.GI3553@twin.jikos.cz>
In-Reply-To: <20171205155433.GI3553@twin.jikos.cz>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On Dec 5, 2017, at 7:54 AM, David Sterba <dsterba@suse.cz> wrote:
> 
> I had a different branch with patches from openSUSE, so the diffs apply with
> minimal efforts to the package. The branch btrfs-zstd has been synced up. The
> ENOMEM error was not from the file decompression but from the zstdio.c module,
> that does something different, now disabled.
> 
> I got a bit further, with a few debugging messages, this check fails:
> 
> 957   total_size = grub_le_to_cpu32 (grub_get_unaligned32 (ibuf));
> 958   ibuf += sizeof (total_size);
> 959
> 960   if (isize < total_size) {
> 961     grub_error (GRUB_ERR_BAD_FS, "ASSERTION: isize < total_size: %ld < %ld",
> 962                     isize, total_size);
> 963     return -1;
> 964   }
> 
> with: "isize < total_size: 61440 < -47205080"
> 
> total_size is u32, but wrngly printed as signed long so it's negative, but
> would be wrong anyway. This looks like the compressed format is not read
> correctly.

The blocks of 4 KB uncompressed data with a u32 containing the compressed
size is part of the btrfs lzo format, so zstd doesn't follow that. The
compressed data is just zstd, with nothing else.

I think I mistook the semantics of grub_btrfs_zstd_decompress() earlier.
If I understand the function correctly, grub_btrfs_zstd_decompress() is
given a compressed block and is asked to read `osize` bytes at offset `off`
of the uncompressed bytes. `osize` may be less than the uncompressed block
size if `off > 0`. Is that correct?

Zstd compressed data is called a "frame", and the frame is made up of
multiple "blocks", each containing up to 128 KB on uncompressed data.
Since btrfs currently passes blocks of up to 128 KB to the compressor,
each frame will contain only one block. Zstd is only able to decompress
at block granularity, so we have to decompress the whole thing.

Since `osize` may be less than the uncompressed size of the zstd frame, we
will need a secondary buffer to decompress into, and then copy the
requested segment into the output buffer.

The code would look something like this:

```
#define BTRFS_ZSTD_WORKSPACE_SIZE_U64 (155984 / sizeof(grub_uint64_t))
static grub_uint64_t zstd_workspace[BTRFS_ZSTD_WORKSPACE_SIZE_U64];

#define ZSTD_BTRFS_MAX_WINDOWLOG 17
#define ZSTD_BTRFS_MAX_INPUT (1 << ZSTD_BTRFS_MAX_WINDOWLOG)
static grub_uint8_t zstd_outbuf[ZSTD_BTRFS_MAX_INPUT];

static grub_ssize_t
grub_btrfs_zstd_decompress(char *ibuf, grub_size_t isize, grub_off_t off,
                          char *obuf, grub_size_t osize)
{
 void *ubuf;
 grub_size_t usize;
 void *const wmem = zstd_workspace;
 grub_size_t const wsize = sizeof(zstd_workspace);
 ZSTD_DCtx *ctx;

 if (wsize < ZSTD_DCtxWorkspaceBound())
   {
      /* Unexpected */
      return -1;
   }
 ctx = ZSTD_initDCtx(wmem, wsize);
 if (!ctx)
   {
      /* Unexpected */
      return -1;
   }

 /* Find the end of the zstd frame given a zstd compressed frame possibly
  * followed by extra data. The returned value will always be an error or
  * <= isize.
  *
  * This is only necessary if there is junk after the end of the zstd
  * compressed data in the input buffer. Otherwise the return value
  * should always be exactly isize. If you delete this, and it always works,
  * then there isn't junk data at the end.
  */
 isize = ZSTD_findFrameCompressedSize(ibuf, isize);
 if (ZSTD_isError(isize))
   {
      /* Corruption */
      return -1;
   }

 /* We don't know the original uncompressed size here (osize might be smaller)
  * so we have to fall back to checking that osize >= ZSTD_BTRFS_MAX_INPUT.
  * If we knew the size, we could relax the check.
  *
  * This is only an optimization, not necessary for correctness.
  */
 if (off == 0 && osize >= ZSTD_BTRFS_MAX_INPUT)
   {
      ubuf = obuf;
      usize = osize;
   }
 else
   {
     ubuf = zstd_outbuf;
     usize = sizeof(zstd_outbuf);
   }

 usize = ZSTD_decompressDCtx(ctx, ubuf, usize, ibuf, isize);
 if (ZSTD_isError(usize))
   {
      /* Corruption */
      return -1;
   }
 /* We need to read osize bytes at offset off.
  * Check that we have enough data.
  */
 if (usize < off + osize)
   {
      /* Corruption */
      return -1;
   }
 /* If we decompressed directly to the output buffer, off must be zero. */
 if (ubuf == obuf)
   {
      assert(off == 0);
      return osize;
   }
 assert(ubuf == zstd_outbuf);
 grub_memcpy(obuf, ubuf + off, osize);
 return osize;
}
```