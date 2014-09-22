Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3747 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753905AbaIVP1o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 11:27:44 -0400
Message-ID: <54203FE9.9040708@fb.com>
Date: Mon, 22 Sep 2014 11:27:37 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs-progs release 3.16.1
References: <20140922152421.GR9715@suse.cz>
In-Reply-To: <20140922152421.GR9715@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/22/2014 11:24 AM, David Sterba wrote:
> Hi,
> 
> this is is a minor release collecting a few bugfixes and enhancements.
> User visible changes:
> 
> * the 'uknown' blockgroup in 'fi df' is properly named 'GlobalReserve'
> * -R option for listing received UUID
> 
> Other updates:
> 
> * library version defines
> * static build is fixed
> * build without documentation is possible
> 
> The kernel.org btrfs-progs git repository is at
> 
> https://git.kernel.org/cgit/linux/kernel/git/kdave/btrfs-progs.git
> 
> and eventually synced to Chris' git tree.
> 

Thanks Dave!  I've sync'd the v3.16.1 git commits over to my tree.

-chris

