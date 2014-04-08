Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31539 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756179AbaDHXsw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Apr 2014 19:48:52 -0400
Message-ID: <53448AFA.4080601@fb.com>
Date: Tue, 8 Apr 2014 19:49:14 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: Upgrade to 3.14.0 messed up raid0 array (btrfs cleaner crashes
 in fs/btrfs/extent-tree.c:5748 and fs/btrfs/free-space-cache.c:1183 )
References: <20140408153609.GE23524@merlins.org> <20140408220903.GV9923@merlins.org>
In-Reply-To: <20140408220903.GV9923@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/08/2014 06:09 PM, Marc MERLIN wrote:
> I forgot to add that while I'm not sure if anyone ended up looking at the
> last image I made regarding
> https://bugzilla.kernel.org/show_bug.cgi?id=72801
>
> I can generate a an image of that filesystem if that helps, or try other
> commands which hopefully won't crash my running server :)
> (filesystem is almost 2TB, so the image will again be big)
>

Hi Marc,

So from the messages it looks like your space cache is corrupted.  Lets 
start with clearing the space cache and running fsck and seeing exactly 
what is wrong.

An image will definitely help if you have a pipe big enough to upload it.

-chris
