Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from alt32.smtp-out.videotron.ca ([24.53.0.21]:29003 "EHLO
        alt32.smtp-out.videotron.ca" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932975AbdA0RDR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Jan 2017 12:03:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 27 Jan 2017 11:47:59 -0500
From: Hans Deragon <hans@deragon.biz>
To: linux-btrfs@vger.kernel.org
Cc: Adam Borowski <kilobyte@angband.pl>
Subject: Re: raid1:  cannot add disk to replace faulty because can only
 mount fs as read-only.
In-Reply-To: <W75Sc6PDCBok7W75TcCgc7@videotron.ca>
References: <54678ac94c95687e00485d41fa5b5bc9@server1.deragon.biz>
 <W75Sc6PDCBok7W75TcCgc7@videotron.ca>
Message-ID: <51114ea93a0f76a5ff6621e4d8983944@server1.deragon.biz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-01-24 14:48, Adam Borowski wrote:

> On Tue, Jan 24, 2017 at 01:57:24PM -0500, Hans Deragon wrote:
> 
>> If I remove 'ro' from the option, I cannot get the filesystem mounted 
>> because of the following error: BTRFS: missing devices(1) exceeds the 
>> limit(0), writeable mount is not allowed So I am stuck. I can only 
>> mount the filesystem as read-only, which prevents me to add a disk.
> 
> A known problem: you get only one shot at fixing the filesystem, but 
> that's
> not because of some damage but because the check whether the fs is in a
> shape is good enough to mount is oversimplistic.
> 
> Here's a patch, if you apply it and recompile, you'll be able to mount
> degraded rw.
> 
> Note that it removes a safety harness: here, the harness got tangled up 
> and
> keeps you from recovering when it shouldn't, but it _has_ valid uses 
> that.
> 
> Meow!

Greetings,

Ok, that solution will solve my problem in the short run, i.e. getting 
my raid1 up again.

However, as a user, I am seeking for an easy, no maintenance raid 
solution.  I wish that if a drive fails, the btrfs filesystem still 
mounts rw and leaves the OS running, but warns the user of the failing 
disk and easily allow the addition of a new drive to reintroduce 
redundancy.  Are there any plans within the btrfs community to implement 
such a feature?  In a year from now, when the other drive will fail, 
will I hit again this problem, i.e. my OS failing to start, booting into 
a terminal, and cannot reintroduce a new drive without recompiling the 
kernel?

Best regards,
Hans Deragon

