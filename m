Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46897 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552AbaIOPzG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 11:55:06 -0400
Message-ID: <54170BCA.7070900@fb.com>
Date: Mon, 15 Sep 2014 11:54:50 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Sam Thursfield <sam.thursfield@codethink.co.uk>,
        <linux-btrfs@vger.kernel.org>
CC: <baserock-dev@baserock.org>
Subject: Re: Unable to mount multiple subvolumes of a single disk
References: <5417022A.5000101@codethink.co.uk>
In-Reply-To: <5417022A.5000101@codethink.co.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/15/2014 11:13 AM, Sam Thursfield wrote:
> Hi!
> 
> I'm having an issue with the 3.17rc5 kernel which prevents having
> multiple subvolumes of the same disk mounted.
> 
> I'm not sure exactly the cause. I thought it might be because in my
> system the root file system is itself a subvolume of the disk I'm trying
> to mount. But if I create a second disk image with two subvolumes, the
> same thing occurs -- I can only mount one of them at a time.
> 
> I've attached the output of a few commands, please let me know if you
> want more info (I'm not subscribed to the list, please keep me in To:).
> 
> We've bisected and found that the exact commit that changed the
> behaviour is this one:
> https://urldefense.proofpoint.com/v1/url?u=https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id%3Db96de000bc8bc9688b3a2abea4332bd57648a49f&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=qVtp3yxxUd8uElAkp118K4Bd0oZfeUOC%2BKUy3e6rRlA%3D%0A&s=0d2623956de100adc1185d2b75e9114384572b88c0330e74924baa1a2bce8d02
> 
> 
> I'm afraid I'm not familiar with the Btrfs code base and so I don't
> understand the exact meaning of the comments in that commit.

Anand Jain is working on this in a separate thread.  I'll make sure the
fix goes into the next rc, thanks for all the time spent bisecting.

-chris

