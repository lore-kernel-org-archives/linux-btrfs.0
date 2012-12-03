Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39907 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab2LCDPD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Dec 2012 22:15:03 -0500
Date: Mon, 3 Dec 2012 11:13:19 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: basic questions regarding some btrfs features
Message-ID: <20121203031318.GA4649@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <CAEx9m478rbpHCSSNsSv4yyOk3-yrAuSk0DQQ23X+iFWMocAhzg@mail.gmail.com>
 <20121202224635.GA7289@carfax.org.uk>
 <8B5B2183-4049-46F5-9116-2FD15FCE4023@colorremedies.com>
 <CAGJTRchOD0_jX-h5=kN-K2cG3cc0jCshfAjP489iA5FY8jS5rg@mail.gmail.com>
 <C09BF2D1-D193-4915-8C57-A712A88F963C@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <C09BF2D1-D193-4915-8C57-A712A88F963C@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 02, 2012 at 07:49:17PM -0700, Chris Murphy wrote:
> 
> On Dec 2, 2012, at 6:59 PM, Michael <mike@draftx.net> wrote:
> 
> > Subvolid=0 is always the root subvolume. 
> 
> OK so then what is subvolid=5?

We've parsed subvolid=5 and subvolid=0 to the same results, FS_TREE.

FYI, the code is
                case Opt_subvolid:              
                        intarg = 0;
                        error = match_int(&args[0], &intarg);
                        if (!error) {
                                /* we want the original fs_tree */
                                if (!intarg)
                                        *subvol_objectid =
                                                BTRFS_FS_TREE_OBJECTID;
                                else
                                        *subvol_objectid = intarg;
                        }
                        break;          

thanks,
liubo
