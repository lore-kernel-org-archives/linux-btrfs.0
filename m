Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47826 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755605AbaD1VGI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Apr 2014 17:06:08 -0400
Message-ID: <535EC2D9.9000609@fb.com>
Date: Mon, 28 Apr 2014 17:06:33 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>, Marc MERLIN <marc@merlins.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Which companies contribute to Btrfs?
References: <20140424011834.GN26949@merlins.org> <20140428150006.087c2357@lwn.net>
In-Reply-To: <20140428150006.087c2357@lwn.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/28/2014 03:00 PM, Jonathan Corbet wrote:
> On Wed, 23 Apr 2014 18:18:34 -0700
> Marc MERLIN <marc@merlins.org> wrote:
>
>> I writing slides about btrfs for an upcoming talk (at linuxcon) and I was
>> trying to gather a list of companies that contribute code to btrfs.
>
> So I just ran into this now.  I did a quick gitdm run over the entire btrfs
> history in the kernel and came up with this:
>
> 	Top changeset contributors by employer
> 	Oracle                    1249 (33.2%)
> 	Fujitsu                    613 (16.3%)
> 	Red Hat                    483 (12.8%)
> 	Fusion-IO                  296 (7.9%)
> 	(None)                     288 (7.6%)
> 	Novell                     203 (5.4%)
> 	STRATO AG                  152 (4.0%)
> 	Couchbase                  106 (2.8%)
> 	(Consultant)                62 (1.6%)
> 	(Unknown)                   54 (1.4%)
> 	Intel                       48 (1.3%)
> 	New Dream Network           36 (1.0%)
> 	Facebook                    31 (0.8%)
> 	IBM                         20 (0.5%)
> 	FOSS Outreach Program for Women   12 (0.3%)
> 	Google                      12 (0.3%)
> 	(Academia)                  11 (0.3%)
> 	Parallels                   11 (0.3%)
> 	HP                          10 (0.3%)
> 	Datera Inc.                  5 (0.1%)
>
> I would expect the rankings to change a bit in the near future, if those
> slackers at Facebook ever get it in gear...:)

Grin, Josef has taken a few weeks off to look after the newly released 
Josefv3.

We've got the pool of web servers on btrfs at 800 now, and soon I'm sure 
it'll start kicking out some fun bugs.

Once we get the btrfs tier up to 1000, I'll have a second slice of 1000 
machines running 3.14 as well (or whatever the current linus rev is).

Those will be btrfs too, I expect the crash recovery code will get quite 
a bit of testing.

-chris
