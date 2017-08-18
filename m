Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:53264 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751045AbdHRXaJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 19:30:09 -0400
Subject: Re: qcow2 images make scrub believe the filesystem is corrupted.
To: Josef Bacik <josef@toxicpanda.com>, kreijack@inwind.it
Cc: Paulo Dias <paulo.miguel.dias@gmail.com>, linux-btrfs@vger.kernel.org
References: <CADJPUQ9awnz30XzGZLGQAUhAqeH5ek6stDN5N5JTzc3dGtdiug@mail.gmail.com>
 <20170817233916.GA25527@destiny>
 <ceb36a9a-b73f-96c1-cb58-24f149b24001@libero.it>
 <20170818174356.GA1526@destiny>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <0bcc37c7-8e4c-3ab5-5689-295d47024d1c@gmx.com>
Date: Sat, 19 Aug 2017 07:29:56 +0800
MIME-Version: 1.0
In-Reply-To: <20170818174356.GA1526@destiny>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月19日 01:43, Josef Bacik wrote:
> On Fri, Aug 18, 2017 at 06:23:18PM +0200, Goffredo Baroncelli wrote:
>> On 08/18/2017 01:39 AM, Josef Bacik wrote:
>> [...]
>>> This is happening because the app (the guest OS in this case, we saw this a lot
>>> with windows guests) is changing the pages while they are in flight.  We
>>> calculate the checksum of the page before it's written, so if it changes while
>>> in flight we'll end up with a csum mismatch.
>>>
>>> To fix this change kvm to not use O_DIRECT or set NODATASUM on your qcow2 image.
>>> You'll have to re-create the image because NODATASUM won't apply to the already
>>> invalid checksums.  Thanks,
>>
>> Hi Josef,
>>
>> could you elaborate: do you are saying that using O_DIRECT is incompatible with DATASUM ?
>>
> 
> No, I'm saying using O_DIRECT with applications that don't protect in-flight
> memory are incompatible with DATASUM.  We have no way of making sure nobody
> touches the page while we're writing it out, so after we calculate the checksum
> any changes to the page are going to cause a checksum mismatch.  O_DIRECT are
> user space pages, there's nothing we can do to stop user space from doing stupid
> things.
> 
> The options I looked into before were things like detecting the page had changed
> since we calculated the checksum, and re-submitting the write.  This punishes
> applications that do the right thing (databases for example) by forcing us to
> calculate checksums twice.

Just curious about this.

Why not just scrubbing data/metadata in commit roots?
And don't use any page cache, but always read them out from disk?

For datacsum case, it's always cowed, so it won't change in-flight.

Although the cost is obvious, such method can only check data/metadata 
in previous trans and doesn't use page cache means tons of IO.

Thanks,
Qu
> 
> This is a shit situation because users aren't going to understand this
> limitation, and it bites them in the ass with all these weird errors.  I think
> maybe we need to go back to the double-checksum thing by default, and have a
> flag or something for users to set if they know their application behaves
> properly.  Thanks,
> 
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
