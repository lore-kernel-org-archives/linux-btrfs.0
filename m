Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61683 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751234AbaBDOHv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Feb 2014 09:07:51 -0500
Message-ID: <52F0F426.7030605@fb.com>
Date: Tue, 4 Feb 2014 09:07:34 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Roger Binns <rogerb@rogerbinns.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: disable snapshot aware defrag for now
References: <1391029530-17686-1-git-send-email-jbacik@fb.com> <20140203144802.GK1364@twin.jikos.cz> <52EFD19C.3050404@fb.com> <lcpm87$15e$1@ger.gmane.org>
In-Reply-To: <lcpm87$15e$1@ger.gmane.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 02/03/2014 10:19 PM, Roger Binns wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 03/02/14 09:27, Josef Bacik wrote:
>> It is so totally broken that I don't want it being turned on by anybody
>> who can't edit this and change it themselves.
> The symptoms I saw are huge amounts of kernel memory consumption, possibly
> till exhaustion of swap.  Are there other ways in which is it broken (eg
> corruption)?
>
> Also is this patch making its way to the various stables?
No corruption, and frankly if you had just small files and a small 
number of snapshots it worked just fine, but otherwise it would use all 
of your ram.  I cc'ed stable@ so it should make it back to all the 
stables.  Thanks,

Josef
