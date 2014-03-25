Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from jeru.org ([188.121.252.211]:53760 "EHLO jeru.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708AbaCYOFc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 10:05:32 -0400
Date: Tue, 25 Mar 2014 14:57:57 +0100
From: Xavier Nicollet <nicollet@jeru.org>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: How to debug very very slow file delete? (btrfs on md-raid5)
Message-ID: <20140325135756.GA14382@jeru.org>
Reply-To: nicollet@jeru.org
References: <20140325014956.GG11533@merlins.org>
 <lgrrtf$el3$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <lgrrtf$el3$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 25 mars 2014 à 12:13, Martin a écrit:
> On 25/03/14 01:49, Marc MERLIN wrote:
> > It took 18H to rm it in 3 tries:

> And is not *the 512kByte raid chunk* going to give you horrendous write
> amplification?! For example, rm updates a few bytes in one 4kByte
> metadata block and the system has to then do a read-modify-write on
> 512kBytes...

My question would be naive, but would it be possible to have a syscall or something to do 
a fast "rm -rf" or du ?

I think ceph might have the later actually.

-- 
Xavier Nicollet
