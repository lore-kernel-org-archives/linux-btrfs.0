Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:59069 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753877Ab2IXL5L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 07:57:11 -0400
Date: Mon, 24 Sep 2012 13:57:04 +0200
From: David Sterba <dave@jikos.cz>
To: Alfredo Esteban <aedelatorre@gmail.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Userland commands repository in wiki
Message-ID: <20120924115704.GA14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAKZ=RP8D04kxn4_YX8xKtjcqWd=BiuWC-DEYD+f4iekwt3WDtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKZ=RP8D04kxn4_YX8xKtjcqWd=BiuWC-DEYD+f4iekwt3WDtw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 21, 2012 at 06:23:36PM +0200, Alfredo Esteban wrote:
> Yesterday, I modified the URL of the userland commands repository in
> this wiki page:
> 
> https://btrfs.wiki.kernel.org/index.php/Debugging_Btrfs_with_GDB
> 
> Former URL doesn't work:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
> 
> I think the correct one is:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
> 
> Please, confirm that my modification is ok.

It's preferred to keep all URIs at a single page,

https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories

Reading through the GDB tutorial page, it seems to come from the old
ages when the progs were not usually packaged and one had to compile it
from sources. The section "Building Btrfs Userland Commands" is IMHO not
neccesary anymore.


david
