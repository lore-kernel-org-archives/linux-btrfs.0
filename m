Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41777 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709Ab3LTXxU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Dec 2013 18:53:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vu9sc-0000uD-TA
	for linux-btrfs@vger.kernel.org; Sat, 21 Dec 2013 00:53:18 +0100
Received: from p5b0064fb.dip0.t-ipconnect.de ([91.0.100.251])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Dec 2013 00:53:18 +0100
Received: from holger.hoffstaette by p5b0064fb.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Dec 2013 00:53:18 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH v3] Btrfs: fix tree mod logging
Date: Fri, 20 Dec 2013 23:52:57 +0000 (UTC)
Message-ID: <pan.2013.12.20.23.53.08@googlemail.com>
References: <1386963698-17766-1-git-send-email-fdmanana@gmail.com>
	<1387552666-10969-1-git-send-email-fdmanana@gmail.com>
	<pan.2013.12.20.23.19.56@googlemail.com>
	<CAL3q7H6GPTJVFEj3SCtoPgOE_qQHs8Zik40HGsxDAY4b6yf9FQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 20 Dec 2013 23:31:44 +0000, Filipe David Manana wrote:

> On Fri, Dec 20, 2013 at 11:19 PM, Holger Hoffstätte
> <holger.hoffstaette@googlemail.com> wrote:
>> On Fri, 20 Dec 2013 15:17:46 +0000, Filipe David Borba Manana wrote:
>>
>> I applied this to 3.12.6 and was rewarded with:
>>
>> *fs/btrfs/ctree.c: In function 'tree_mod_log_set_node_key':
> 
> Did you apply first the patch titled "Btrfs: return immediately if tree
> log mod is not necessary" ?

No, of course not. =)

Looking at that one makes things clear and applying it first fixed it. 
Everything built fine and seems to work, no spontaneous combustions yet.

Thanks!

-h

