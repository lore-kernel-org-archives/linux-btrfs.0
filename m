Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:35559 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932589AbcJLK7u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 06:59:50 -0400
Received: by mail-it0-f65.google.com with SMTP id l13so3730542itl.2
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Oct 2016 03:59:49 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1476239328-24649-1-git-send-email-ce3g8jdj@umail.furryterror.org>
References: <1476239328-24649-1-git-send-email-ce3g8jdj@umail.furryterror.org>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 12 Oct 2016 09:59:03 +0100
Message-ID: <CAL3q7H7ADJy9ERaVsvgp4vrVdQ4ObHRikmE7SBELSNC5g3an2Q@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix silent data corruption while reading
 compressed inline extents
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2016 at 3:28 AM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
> rsync -S causes a large number of small writes separated by small seeks
> to form sparse holes in files that contain runs of zero bytes.  Rarely,
> this can lead btrfs to write a file with a compressed inline extent
> followed by other data, like this:
>
> Filesystem type is: 9123683e
> File size of /try/./30/share/locale/nl/LC_MESSAGES/tar.mo is 61906 (16 blocks of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..    4095:          0..      4095:   4096:             encoded,not_aligned,inline
>    1:        1..      15:     331372..    331386:     15:          1: last,encoded,eof
> /try/./30/share/locale/nl/LC_MESSAGES/tar.mo: 2 extents found

So that's the problem. We should never have non-inlined extents after
an inline extent (this causes problems in many places) - the only
exception is for pre-allocated extents created with fallocate using
its flag FALLOC_FL_KEEP_SIZE (so that the inode size doesn't change).

btrfs_cont_expand() is responsible for inserting holes, and for the
first page, which is where the inline extent belongs to, it pads it
with zeroes (done through btrfs_truncate_block()). So the bug here is
some corner case where we don't do this hole expansion thing and end
up with an inline extent followed by some non-inlined one and with an
isize (file size) greater than the uncompressed size of the inline
extent.

Given how hard the bug is to trigger with your reproducer below, and
that you didn't find a way to trigger it using deterministic steps
like for example:

for ((i = 1; i <= 1000; i++)); do
umount /dev/sdd &> /dev/null
mkfs.btrfs -f /dev/sdd > /dev/null
mount -o compress=lzo /dev/sdd /mnt/sdd
xfs_io -f -c "pwrite -S 0xaa 0 1500" /mnt/sdd/foobar > /dev/null
sync
xfs_io -c "pwrite -S 0xbb 1M 4K" /mnt/sdd/foobar > /dev/null
DIGEST1=$(md5sum /mnt/sdd/foobar | cut -d ' ' -f 1)
echo 3 > /proc/sys/vm/drop_caches
DIGEST2=$(md5sum /mnt/sdd/foobar | cut -d ' ' -f 1)
echo -e "\n\nIteration $i\n"
echo "Digest1 = $DIGEST1"
echo "Digest2 = $DIGEST2"
echo
if [ "$DIGEST1" != "$DIGEST2" ]; then
exit 1
fi
done

It's more than evidence that your fix is only hidding away the real problem.

Once it's figured out why this happens, we should ideally have a
deterministic or easy to trigger reproducer for xfstests.

thanks

>
> The inline extent size is less than the page size, so the ram_bytes field
> in the extent is smaller than 4096.  The difference between ram_bytes and
> the end of the first page of the file forms a small hole.  Like any other
> hole, the correct value of each byte within the hole is zero.
>
> When the inline extent is not compressed, btrfs_get_extent copies the
> inline extent data and then memsets the remainder of the page to zero.
> There is no corruption in this case.
>
> When the inline extent is compressed, uncompress_inline uses the
> ram_bytes field from the extent ref as the size of the uncompressed data.
> ram_bytes is smaller than the page size, so the remainder of the page
> (i.e. the bytes in the small hole) is uninitialized memory.  Each time the
> extent is read into the page cache, userspace may see different contents.
>
> Fix this by zeroing out the difference between the size of the
> uncompressed inline extent and PAGE_CACHE_SIZE in uncompress_inline.
>
> Only bytes within the hole are affected, so affected files can be read
> correctly with a fixed kernel.  The corruption happens after IO and
> checksum validation, so the corruption is never reported in dmesg or
> counted in dev stats.
>
> The bug is at least as old as 3.5.7 (the oldest kernel I can conveniently
> test), and possibly much older.
>
> The code may not be correct if the extent is larger than a page, so add
> a WARN_ON for that case.
>
> To reproduce the bug, run this on a 3072M kvm VM:
>
>         #!/bin/sh
>         # Use your favorite block device here
>         blk=/dev/vdc
>
>         # Create test filesystem and mount point
>         mkdir -p /try
>         mkfs.btrfs -dsingle -mdup -O ^extref,^skinny-metadata,^no-holes -f "$blk" || exit 1
>         mount -ocompress-force,flushoncommit,max_inline=8192,noatime "$blk" /try || exit 1
>
>         # Create a few inline extents in larger files.
>         # Multiple processes seem to be necessary.
>         y=/usr; for x in $(seq 10 19); do rsync -axHSWI "$y/." "$x"; y="$x"; done &
>         y=/usr; for x in $(seq 20 29); do rsync -axHSWI "$y/." "$x"; y="$x"; done &
>         y=/usr; for x in $(seq 30 39); do rsync -axHSWI "$y/." "$x"; y="$x"; done &
>         y=/usr; for x in $(seq 40 49); do rsync -axHSWI "$y/." "$x"; y="$x"; done &
>         wait
>
>         # Make a list of the files with inline extents
>         touch /try/list
>         find -type f -size +4097c -exec sh -c 'for x; do if filefrag -v "$x" | sed -n "4p" | grep -q "inline"; then echo "$x" >> list; fi; done' -- {} +
>
>         # Check the inline extents to see if they change as they are read multiple times
>         while read -r x; do
>                 sum="$(sha1sum "$x")"
>                 for y in $(seq 0 99); do
>                         sysctl vm.drop_caches=1
>                         sum2="$(sha1sum "$x")"
>                         if [ "$sum" != "$sum2" ]; then
>                                 echo "Inconsistent reads from '$x'"
>                                 exit 1
>                         fi
>                 done
>         done < list
>
> The reproducer may need to run up to 20 times before it finds a
> corruption.
>
> Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
> ---
>  fs/btrfs/inode.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e6811c4..34f9c80 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6791,6 +6791,12 @@ static noinline int uncompress_inline(struct btrfs_path *path,
>         max_size = min_t(unsigned long, PAGE_SIZE, max_size);
>         ret = btrfs_decompress(compress_type, tmp, page,
>                                extent_offset, inline_size, max_size);
> +       WARN_ON(max_size > PAGE_SIZE);
> +       if (max_size < PAGE_SIZE) {
> +               char *map = kmap(page);
> +               memset(map + max_size, 0, PAGE_SIZE - max_size);
> +               kunmap(page);
> +       }
>         kfree(tmp);
>         return ret;
>  }
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"People will forget what you said,
 people will forget what you did,
 but people will never forget how you made them feel."
