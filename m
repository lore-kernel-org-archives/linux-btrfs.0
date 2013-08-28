Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:51750 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096Ab3H1Rfs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Aug 2013 13:35:48 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id CCECE388818
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Aug 2013 19:35:44 +0200 (CEST)
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs device delete missing -> kernel BUG at  fs/btrfs/relocation.c:1055!
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 28 Aug 2013 19:35:44 +0200
From: Tomasz Chmielewski <tch@virtall.com>
In-Reply-To: <0ce5885cea6d25abb00e393355d86a00@admin.virtall.com>
References: <0ce5885cea6d25abb00e393355d86a00@admin.virtall.com>
Message-ID: <f5edd93b5c7a8baf47ea6284470027a9@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013-08-28 17:40, Tomasz Chmielewski wrote:
> Just tried to remove a broken disk, which ended in segmentation fault
> and kernel BUG.
> 
> Any advice what to do next? This is on 3.11.0-rc7.

Ah, I see this one helped:

https://patchwork.kernel.org/patch/2835923/


-- 
Tomasz Chmielewski
http://wpkg.org

