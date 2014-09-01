Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22595 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753438AbaIAQDB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Sep 2014 12:03:01 -0400
Message-ID: <540498AF.6030109@fb.com>
Date: Mon, 1 Sep 2014 12:02:55 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: john terragon <jterragon@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: kernel 3.17-rc3: task rsync:2524 blocked for more than 120 seconds
References: <CANg_oxzqyr3Jcx-8ntPPntjVmRjWqheUqaWOWpkhh5Rrw3Ayrw@mail.gmail.com>
In-Reply-To: <CANg_oxzqyr3Jcx-8ntPPntjVmRjWqheUqaWOWpkhh5Rrw3Ayrw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/01/2014 09:33 AM, john terragon wrote:
> Hi.
> 
> I'm not sure if this is related to the hung task problem that I've
> been seeing in this ml for a while. But  I've been having this
> seemingly related problem with 3.15, 3.16 and now 3.17-rc3 (which, if
> I'm not mistaken, should have a fix for the hung task problem). So
> here it is: I have a usb flash drive with btrfs (on top of dmcrypt)
> usually mounted with these options
> 
> rw,noatime,compress-force=zlib,ssd,space_cache,autodefrag
> 
> When I try to rsync the usb flash drive I get a truck-load of "INFO:
> task rsync:2524 blocked for more than 120 seconds" as you can see
> below.
> The rsync process crawls into an almost complete stop and I can't even
> kill it. I know the usb key is OK because I've tried the same thing
> with ext4 and xfs and everything went fine.

This does have all of our fixes for hangs.  Does the rsync eventually
complete?  Or do we just sit there forever?

-chris
