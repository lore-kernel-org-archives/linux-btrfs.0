Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:57838 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751064AbdBAWvi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Feb 2017 17:51:38 -0500
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id E57C59B85D
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Feb 2017 22:51:34 +0000 (GMT)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id 701835FBB3
        for <linux-btrfs@vger.kernel.org>; Wed,  1 Feb 2017 22:51:34 +0000 (GMT)
Subject: Re: btrfs receive leaves new subvolume modifiable during operation
To: linux-btrfs@vger.kernel.org
References: <1485905578.6441.20.camel@gmail.com>
 <pan$4ecd$16bc5e8e$14657c4$261368ad@cox.net>
 <4edfd08e-8d7f-d8d7-bdea-0589b46e4d2b@gmail.com>
 <7ead5d42-9c00-b2df-3fbf-5b8f287760f6@cobb.uk.net>
 <pan$16525$cf7fe24b$7c044b9$74b32f27@cox.net>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <5c503d69-aaed-680f-de30-75a7323bc753@cobb.uk.net>
Date: Wed, 1 Feb 2017 22:51:34 +0000
MIME-Version: 1.0
In-Reply-To: <pan$16525$cf7fe24b$7c044b9$74b32f27@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/02/17 22:27, Duncan wrote:
> Graham Cobb posted on Wed, 01 Feb 2017 17:43:32 +0000 as excerpted:
> 
>> This first bug is more serious because it appears to allow a
>> non-privileged user to disrupt the correct operation of receive,
>> creating a form of denial-of-service of a send/receive based backup
>> process. If I decided that I didn't want my pron collection (or my
>> incriminating emails) appearing in the backups I could just make sure
>> that I removed them from the receive snapshots while they were still
>> writeable.
> 
> I'll prefix this question by noting that my own use-case doesn't use send/
> receive, so while I know about it in general from following the list, 
> I've no personal experience with it...
> 
> With that said, couldn't the entire problem be eliminated by properly 
> setting the permissions on a directory/subvol upstream of the received 
> snapshot?  

I (honestly) don't know. But even if that does work, it is clearly only
a workround for the bug. Where in the documentation does it warn the
system manager about the problem? Where does it tell them that they had
better make sure they only receive into a directory tree which does not
allow users read or execute access (not just not write access!)? What if
part of the point of the backup strategy is that user's have read access
to these snapshots so they can restore their own files?

The possibility of a knowledgeable system manager being able to
workround the problem by limiting how they use it doesn't stop it being
a bug.
