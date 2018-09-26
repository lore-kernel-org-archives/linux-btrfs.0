Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6C4C43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 20:40:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0A6A21531
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 20:40:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=libero.it header.i=@libero.it header.b="dOMpgIFl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0A6A21531
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=libero.it
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbeI0CzZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 22:55:25 -0400
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:46723 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726623AbeI0CzZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 22:55:25 -0400
Received: from venice.bhome ([84.223.214.84])
        by smtp-34.iol.local with ESMTPA
        id 5GbsgzzuCq9Au5Gbsgj9YS; Wed, 26 Sep 2018 22:40:37 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2014;
        t=1537994437; bh=Azmo0U4eGmWW3WYlb0sUZUl9D6iR5ctyG+ziLLT91D8=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=dOMpgIFlnoYvb4iGrMIg0yrEGyP9uvV4yv1sjbvaGMESw03A4v83Jr2VdA5rBpOBF
         DCiVW0+44lAdpA4IRgWeSeemwiIV0MSV24xXh7Hny7xI1Z8KgZg60PJ0KOhCfjVASj
         81ijT10SV/PDTVfuvnqAr+QC1EM65Cxy585MSSCmdGoOKH9ywHp4Bb4rh5nsVUTVlY
         vXn939oKrY6O+bcvmAL74nKyL1Vx3B6NMi7jW5p0L6QIvnSrEHG/SL2BqXVpeMXD05
         NOKhkfnTLxKUwygM6RqXhjs5xQat0Gh6tNXER9x663QQdJ0Txdf8bz3t0SiOa4+jJk
         dgwDoQXcZpnQg==
X-CNFS-Analysis: v=2.3 cv=OoWeNB3t c=1 sm=1 tr=0
 a=8ZjQKV1YVqnHfcWpVNE1cw==:117 a=8ZjQKV1YVqnHfcWpVNE1cw==:17
 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=ChAbMjvVsfdyXUl2cokA:9
 a=Ct2Hl-u6UnrpNnY_:21 a=no5Rjb6IG-8amn-3:21 a=QEXdDO2ut3YA:10
 a=RMblk7DMegEA:10 a=AjGcO6oz07-iQ99wixmX:22
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 1/9] btrfs: Add support for reading a filesystem with a
 RAID 5 or RAID 6 profile.
To:     Daniel Kiper <dkiper@net-space.pl>
Cc:     grub-devel@gnu.org, linux-btrfs@vger.kernel.org,
        Goffredo Baroncelli <kreijack@inwind.it>
References: <20180919184040.22540-1-kreijack@libero.it>
 <20180919184040.22540-2-kreijack@libero.it>
 <20180925153142.GA30715@router-fw-old.i.net-space.pl>
From:   Goffredo Baroncelli <kreijack@libero.it>
Openpgp: preference=signencrypt
Autocrypt: addr=kreijack@libero.it; prefer-encrypt=mutual; keydata=
 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
Message-ID: <01115a89-3397-3cad-73b1-10495e11cb61@libero.it>
Date:   Wed, 26 Sep 2018 22:40:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <20180925153142.GA30715@router-fw-old.i.net-space.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfLszcr+Id76Qjo6OsOjWD99WM1DPDthxB+13nG516H0xM0v+iPHWXNzUqHc86yW+6bKneNYT27bmlWcMeLRH2VcspBTEkx+fvgSMMp053CkR6AfkWWhj
 bS4AAGpvi1wVGuaX1nJeAWr2k1G3HeAMURw9HA2VjAsBblyF9IoxWk4z8cUi1UakgpHMDxv1ccnRaJd5hC5rC3A51ilzshxwbqGOixMB26TDCU+Fr2tCZqLQ
 85Nh5AFxwq8yH6q2Jyg+hmDvWETXWQNhb+I0EiCoKKg=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 25/09/2018 17.31, Daniel Kiper wrote:
> On Wed, Sep 19, 2018 at 08:40:32PM +0200, Goffredo Baroncelli wrote:
>> From: Goffredo Baroncelli <kreijack@inwind.it>
>>
>> Signed-off-by: Goffredo Baroncelli <kreijack@inwind.it>
>> ---
>>  grub-core/fs/btrfs.c | 66 ++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 66 insertions(+)
>>
>> diff --git a/grub-core/fs/btrfs.c b/grub-core/fs/btrfs.c
>> index be195448d..56c42746d 100644
>> --- a/grub-core/fs/btrfs.c
>> +++ b/grub-core/fs/btrfs.c
>> @@ -119,6 +119,8 @@ struct grub_btrfs_chunk_item
>>  #define GRUB_BTRFS_CHUNK_TYPE_RAID1         0x10
>>  #define GRUB_BTRFS_CHUNK_TYPE_DUPLICATED    0x20
>>  #define GRUB_BTRFS_CHUNK_TYPE_RAID10        0x40
>> +#define GRUB_BTRFS_CHUNK_TYPE_RAID5         0x80
>> +#define GRUB_BTRFS_CHUNK_TYPE_RAID6         0x100
>>    grub_uint8_t dummy2[0xc];
>>    grub_uint16_t nstripes;
>>    grub_uint16_t nsubstripes;
>> @@ -764,6 +766,70 @@ grub_btrfs_read_logical (struct grub_btrfs_data *data, grub_disk_addr_t addr,
>>  	      stripe_offset = low + chunk_stripe_length
>>  		* high;
>>  	      csize = chunk_stripe_length - low;
>> +	      break;
>> +	    }
>> +	  case GRUB_BTRFS_CHUNK_TYPE_RAID5:
>> +	  case GRUB_BTRFS_CHUNK_TYPE_RAID6:
>> +	    {
>> +	      grub_uint64_t nparities, block_nr, high, low;
>> +
>> +	      redundancy = 1;	/* no redundancy for now */
>> +
>> +	      if (grub_le_to_cpu64 (chunk->type) & GRUB_BTRFS_CHUNK_TYPE_RAID5)
>> +		{
>> +		  grub_dprintf ("btrfs", "RAID5\n");
>> +		  nparities = 1;
>> +		}
>> +	      else
>> +		{
>> +		  grub_dprintf ("btrfs", "RAID6\n");
>> +		  nparities = 2;
>> +		}
>> +
>> +	      /*
>> +	       * A RAID 6 layout consists of several blocks spread on the disks.
>> +	       * The raid terminology is used to call all the blocks of a row
>> +	       * "stripe". Unfortunately the BTRFS terminology confuses block
> 
> Stripe is data set or parity (parity stripe) on one disk. Block has
> different meaning. Please stick to btrfs terminology and say it clearly
> in the comment. And even add a link to btrfs wiki page to ease reading.
> 
> I think about this one:
>   https://btrfs.wiki.kernel.org/index.php/Manpage/mkfs.btrfs#BLOCK_GROUPS.2C_CHUNKS.2C_RAID
> 
>> +	       * and stripe.
> 
> I do not think so. Or at least not so much...

Trust me, generally speaking stripe is the "row" in the disks (without the parity); looking at the ext3 man page:

....
                   stride=stride-size
                          Configure  the  filesystem  for  a  RAID  array with
                          stride-size filesystem blocks. This is the number of
                          blocks  read or written to disk before moving to the
                          next disk, which is sometimes  referred  to  as  the
                          chunk   size.   This  mostly  affects  placement  of
                          filesystem metadata like bitmaps at mke2fs  time  to
                          avoid  placing them on a single disk, which can hurt
                          performance.  It may also be used by the block allo‐
                          cator.

                   stripe_width=stripe-width
                          Configure  the  filesystem  for  a  RAID  array with
                          stripe-width filesystem blocks per stripe.  This  is
                          typically  stride-size * N, where N is the number of
                          data-bearing disks in the  RAID  (e.g.  for  RAID  5
                          there is one parity disk, so N will be the number of
                          disks in the array minus 1).  This allows the  block
                          allocator to prevent read-modify-write of the parity
                          in a RAID stripe if possible when the data is  writ‐
                          ten.

....
Looking at the RAID5 wikipedia page, it seems that the term "stripe" is coherent with the ext3 man page.

I suspect that the confusion is due to the fact that in RAID1 a stripe is in ONE disk (because the others are like parities). In BTRFS the RAID5/6 code uses the structure of RAID1 with some minimal extensions...

To be clear, I don't have problem to be adherent to the BTRFS terminology. However I found this very confusing because I was used to a different terminology. I am bit worried about the fact that grub uses both MD/DM code and BTRFS code; a quick look to the code (eg ./grub-core/disk/diskfilter.c) shows that the stripe_size field seems to be related to a disks row without parities.

And... yes in BTRFS "chunk" is a completely different beast than what it is reported in the ext3 man page :-)


> 
>> +	       *
>> +	       *   Disk0  Disk1  Disk2  Disk3
>> +	       *
>> +	       *    A1     B1     P1     Q1
>> +	       *    Q2     A2     B2     P2
>> +	       *    P3     Q3     A3     B3
>> +	       *  [...]
>> +	       *
>> +	       *  Note that the placement of the parities depends on row index.
>> +	       *  In the code below:
>> +	       *  - block_nr is the block number without the parities
> 
> Well, it seems to me that the btrfs code introduces confusion not the
> spec itself. I would leave code as is but s/block number/stripe number/.

Ok I will replace the two terms. However I have to put a warning that this is a "BTRFS" terminology :-)
> 
>> +	       *    (A1 = 0, B1 = 1, A2 = 2, B2 = 3, ...),
>> +	       *  - high is the row number (0 for A1...Q1, 1 for Q2...P2, ...),
>> +	       *  - stripen is the disk number (0 for A1,Q2,P3, 1 for B1...),
> 
> s/disk number/disk number in a row/

This value doesn't depend by the row. So "number of disk" is more correct
> 
>> +	       *  - off is the logical address to read
>> +	       *  - chunk_stripe_length is the size of a block (typically 64k),
> 
> s/a block/a stripe/
> 
>> +	       *  - nstripes is the number of disks,
> 
> s/number of disks/number of disks in a row/
ditto


> 
> I miss the description of nparities here...

Right:
+              *  - nparities is the number of parities (1 for RAID5, 2 for RAID6);
+              *    used only in RAID5/6 code.

> 
>> +	       *  - low is the offset of the data inside a stripe,
>> +	       *  - stripe_offset is the disk offset,
> 
> s/the disk offset/the data offset in an array/?

Yes

> 
>> +	       *  - csize is the "potential" data to read. It will be reduced to
>> +	       *    size if the latter is smaller.
>> +	       */
>> +	      block_nr = grub_divmod64 (off, chunk_stripe_length, &low);
>> +
>> +	      /*
>> +	       * stripen is computed without the parities (0 for A1, A2, A3...
>> +	       * 1 for B1, B2...).
>> +	       */
>> +	      high = grub_divmod64 (block_nr, nstripes - nparities, &stripen);
> 
> This is clear...
> 
>> +	      /*
>> +	       * stripen is recomputed considering the parities (0 for A1, 1 for
>> +	       * A2, 2 for A3....).
>> +	       */
>> +	      grub_divmod64 (high + stripen, nstripes, &stripen);
> 
> ... but this looks strange... You add disk number to row number. Hmmm...
> It looks that it works but this is not obvious at first sight. Could you
> explain that?

What about
+	      /*
+	       * stripen is recomputed considering the parities: different row have
+              * a different offset, we have to add to stripen the number of row ("high") in 
+              * modulo nstripes (0 for A1, 1 for A2, 2 for A3....).
+	       */

> 
>> +	      stripe_offset = low + chunk_stripe_length * high;
>> +	      csize = chunk_stripe_length - low;
>> +
>>  	      break;
>>  	    }
>>  	  default:
> 
> Daniel
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
