Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([85.222.100.130]:38999 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545Ab2LNSEj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Dec 2012 13:04:39 -0500
Received: from [85.222.100.130] (zlom.siedziba.pl [85.222.100.130])
	by zlom.siedziba.pl (Postfix) with ESMTPSA id D1026861EE5
	for <linux-btrfs@vger.kernel.org>; Fri, 14 Dec 2012 19:04:35 +0100 (CET)
Message-ID: <50CB6A33.9070809@siedziba.pl>
Date: Fri, 14 Dec 2012 19:04:35 +0100
From: =?UTF-8?B?UGlvdHIgUGF3xYJvdw==?= <pp@siedziba.pl>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: no activity in kernel.org btrfs-progs git repo?
References: <20121212224214.GA9195@lenny.home.zabbo.net>
In-Reply-To: <20121212224214.GA9195@lenny.home.zabbo.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
> It looks like it's been a bit more than two months since
>
>    http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs.git;a=summary

Try git://github.com/josefbacik/btrfs-progs

I just spent whole day debugging btrfs-restore, fixing signed / unsigned 
comparisons, adding another mirror retry, only to find out it is all 
already done in this repository. D'oh!

Regards
