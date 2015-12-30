Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58076 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253AbbL3MAW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 07:00:22 -0500
Subject: Re: [PATCH] BTRFS: Adds an option to select RAID Stripe size
To: Sanidhya Solanki <jpage.lkml@gmail.com>, David Sterba <dsterba@suse.cz>,
        calestyo@scientia.net
References: <1451305451-31222-1-git-send-email-jpage.lkml@gmail.com>
 <20151229133907.GA4227@suse.cz> <20151229061512.79a41f31@gmail.com>
 <20151229170611.GB4227@suse.cz> <20151230013946.7c1f0e12@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5683C714.4040705@gmx.com>
Date: Wed, 30 Dec 2015 19:59:16 +0800
MIME-Version: 1.0
In-Reply-To: <20151230013946.7c1f0e12@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/30/2015 02:39 PM, Sanidhya Solanki wrote:
> On Tue, 29 Dec 2015 18:06:11 +0100
> David Sterba <dsterba@suse.cz> wrote:
>
>> So you want to make the stripe size configurable?...
>
> As I see it there are 3 ways to do it:
> -Make it a compile time option that only configures it for a single
> system with any devices that are added to the RAID.
> -Make it a runtime option that can change based on how the
> administrator configures it.
> -A non-user facing option that is configurable by someone like a
> distribution maintainer for all systems using the Binary Distribution.

Not really sure about the difference between 2 and 3.

When you mention runtime option, did you mean ioctl/mount/balance 
convert option?

And what's the third one? Default mkfs time option?

If you can make it mkfs time option, it won't be really hard to make it 
configurable.

>
> As I see it, DS would like something like the third option, but CAM
> (ostensibly a SysAdmin) wants the second option.

I didn't consider David means something that.

As far as I read, he means balance convert option along with mkfs option.

>
> On the other hand, I implemented the first option.

At least from what I have learned in recent btrfs development, either we 
provide a good enough interfaces (normally, balance convert ioctl with 
mkfs time option) to configure some on-disk fields.

Or we just leave it to fixed value(normally 0, just like for encryption 
of EXTENT_DATA, and that's the case for current stripe_size).

So fixed kernel value is not a really good idea, and should at least be 
replace by mkfs time option.

>
> The first and third option can co-exit, the second is an orthogonal
> target that needs to be setup separately.
>
> Or we can make all options co-exist, but make it more complicated.

No need.
Just refer to how btrfs kernel handle chunk profile.

It can be specified at mkfs time (by -d and -m options), and can also be 
converted later by balance ioctl. (by btrfs balance convert filter).

The only tricky thing I am a little considered about is, how do we keep 
the default chunk stripe size for a fs.

Thanks,
Qu
>
> Please let me know which implementation is preferable, and, if you just
> want me to expand the description (as DS' mail asked for) or redo the
> entire setup.
>
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
