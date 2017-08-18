Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17-i6.italiaonline.it ([212.48.14.163]:42848 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750988AbdHRWUC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Aug 2017 18:20:02 -0400
Reply-To: kreijack@inwind.it
Subject: Re: qcow2 images make scrub believe the filesystem is corrupted.
To: Josef Bacik <josef@toxicpanda.com>
Cc: Paulo Dias <paulo.miguel.dias@gmail.com>, linux-btrfs@vger.kernel.org
References: <CADJPUQ9awnz30XzGZLGQAUhAqeH5ek6stDN5N5JTzc3dGtdiug@mail.gmail.com>
 <20170817233916.GA25527@destiny>
 <ceb36a9a-b73f-96c1-cb58-24f149b24001@libero.it>
 <20170818174356.GA1526@destiny>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <5165a965-ef9d-9db3-d618-f9bef6bfbe5e@inwind.it>
Date: Sat, 19 Aug 2017 00:19:59 +0200
MIME-Version: 1.0
In-Reply-To: <20170818174356.GA1526@destiny>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/18/2017 07:43 PM, Josef Bacik wrote:
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
> memory are incompatible with DATASUM.  

This is what I call an 'incompatibility'. Even is a "corner" case, it is still an incompatibility. And to be honest, it is still difficult to say that a "VM" is a "corner" case.

> We have no way of making sure nobody
> touches the page while we're writing it out, so after we calculate the checksum
> any changes to the page are going to cause a checksum mismatch.  O_DIRECT are
> user space pages, there's nothing we can do to stop user space from doing stupid
> things.

I understand the technical difficulties; however I can't agree about "user space [...] doing *stupid* things". If it is not explicitly forbidden, it is legal; not "stupid"

How the application know that the page aren't in-flight anymore ? It is sufficient to wait the end of the write() syscall ? Or it has to wait the end of a fsync() ?
 
> The options I looked into before were things like detecting the page had changed
> since we calculated the checksum, and re-submitting the write.  This punishes
> applications that do the right thing (databases for example) by forcing us to
> calculate checksums twice.

There are other "cases" where it is possible to have the same problem ? It is the same for mmap() ?

> 
> This is a shit situation because users aren't going to understand this
> limitation, and it bites them in the ass with all these weird errors.  I think
> maybe we need to go back to the double-checksum thing by default, and have a
> flag or something for users to set if they know their application behaves
> properly.  

Or... disable checksum for the "O_DIRECT" writings... If you can't trust the checksums at 100%, these don't make sense.

> 
> Josef
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
