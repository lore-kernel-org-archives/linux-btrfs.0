Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:32903 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdHRS0B (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 14:26:01 -0400
Received: by mail-qk0-f175.google.com with SMTP id a77so57365548qkb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Aug 2017 11:26:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170818175939.GA25986@lim.localdomain>
References: <CADJPUQ9awnz30XzGZLGQAUhAqeH5ek6stDN5N5JTzc3dGtdiug@mail.gmail.com>
 <20170817233916.GA25527@destiny> <ceb36a9a-b73f-96c1-cb58-24f149b24001@libero.it>
 <20170818175939.GA25986@lim.localdomain>
From: Paulo Dias <paulo.miguel.dias@gmail.com>
Date: Fri, 18 Aug 2017 15:25:39 -0300
Message-ID: <CADJPUQ-DEFbGeXeBKqraWNZt8qrvrK+9RkduMJs0E8oCOXhsPA@mail.gmail.com>
Subject: Re: qcow2 images make scrub believe the filesystem is corrupted.
To: bo.li.liu@oracle.com
Cc: kreijack@inwind.it, Josef Bacik <josef@toxicpanda.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

HI all..

So this sucks, having to check every single disk image so it wont get
corrupted stuff, while it works on other filesystems isn't exactly
stellar.

i changed the qcow2 settings per this page:
https://pve.proxmox.com/wiki/Performance_Tweaks

i went with cache=writeback since it neither uses O_DSYNC nor O_DIRECT
semantics.

I understand the reasons checksumming might fail and that isn't
exactly btrfs fault but i scoured the entire btrfs wiki and couldnt
find anything warning about btrfs + qcow2 (or other image types) in
the wiki pages. Maybe adding some warning would help unlucky ppl like
myself?

Also, is is safe to enable compress=lzo , or is it also a no no, im
also starting to suspect that discard wasnt the culprit since i have
it enabled for more then a year and the only problem i got with
corruption was precisely this images?
| Paulo Dias
| paulo.miguel.dias@gmail.com

Tempora mutantur, nos et mutamur in illis.


On Fri, Aug 18, 2017 at 2:59 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Fri, Aug 18, 2017 at 06:23:18PM +0200, Goffredo Baroncelli wrote:
>> On 08/18/2017 01:39 AM, Josef Bacik wrote:
>> [...]
>> > This is happening because the app (the guest OS in this case, we saw this a lot
>> > with windows guests) is changing the pages while they are in flight.  We
>> > calculate the checksum of the page before it's written, so if it changes while
>> > in flight we'll end up with a csum mismatch.
>> >
>> > To fix this change kvm to not use O_DIRECT or set NODATASUM on your qcow2 image.
>> > You'll have to re-create the image because NODATASUM won't apply to the already
>> > invalid checksums.  Thanks,
>>
>> Hi Josef,
>>
>> could you elaborate: do you are saying that using O_DIRECT is incompatible with DATASUM ?
>>
>
> They're compatible, but applications need to be careful.
>
> O_DIRECT takes userspace page, and it works like
> DIO write
>   p = get_user_page();
>   add p to bio
>   #btrfs submits this bio
>   calc_checksum(bio);
>   submit_bio();
>
> There's a chance that page p got changed between calc_checksum() and
> submit_bio(), which then causes the mismatch.
>
> For buffered IO, dirty page cache pages is synchronized with page
> fault by page lock and page writeback bit.
>
> thanks,
> -liubo
