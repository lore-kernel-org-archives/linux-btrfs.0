Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61559 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130AbbE1OND (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 May 2015 10:13:03 -0400
Message-ID: <55672267.8030101@fb.com>
Date: Thu, 28 May 2015 10:12:55 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: specify mountpoint for recieve
References: <1432749089-14663-1-git-send-email-jbacik@fb.com> <20150528123750.GR23255@twin.jikos.cz>
In-Reply-To: <20150528123750.GR23255@twin.jikos.cz>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/28/2015 08:37 AM, David Sterba wrote:
> On Wed, May 27, 2015 at 01:51:29PM -0400, Josef Bacik wrote:
>> In a chroot environment we may not have /proc mounted, which makes btrfs receive
>> freak out since it wants to know the base directory where are are mounted for
>> things like clone and such
>
> Does this https://patchwork.kernel.org/patch/6456671/ fix the problem
> with clones?
>

So that patch is for using the -C option, which chroot's before doing a 
receive.  What I'm doing is when we're already in a chroot'ed 
environment, not using -C, so don't have access to /proc.  Thanks,

Josef
