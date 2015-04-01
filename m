Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37583 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751910AbbDABj2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 21:39:28 -0400
Date: Tue, 31 Mar 2015 21:39:21 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: readdir tree/page lock inversion
To: Zach Brown <zab@zabbo.net>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1427852361.24929.2@mail.thefacebook.com>
In-Reply-To: <20150331234553.GA20542@lenny.home.zabbo.net>
References: <20150331234553.GA20542@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 31, 2015 at 7:45 PM, Zach Brown <zab@zabbo.net> wrote:
> We've known for eons that it's not great that readdir holds tree locks
> while calling mkwrite by way of dir_emit().  I fiddled around and 
> found
> a reliable if goofy deadlock reproducer.  It typically takes a few
> seconds on modest hardware here (single package, dual core/ht, single
> spindle.)
> 
> I made a quick attempt at refactoring readdir to stage entries in a
> locally allocated page before releasing the locks and emitting them 
> but
> unfortunately my eyeballs fell out and one of the cats ran off with
> them.  Maybe someone else will have more luck.

Ok, copying into a temporary page (or just a temp extent buffer) really 
is the best way.  Basically copy out the extent buffer right after the 
btrfs_search_slot and then process the local copy.

I'll take a look for the merge window.

-chris



