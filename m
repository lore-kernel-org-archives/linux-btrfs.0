Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:44978 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751107AbdL2RH6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Dec 2017 12:07:58 -0500
Received: from tux.wizards.de (p5DE2B793.dip0.t-ipconnect.de [93.226.183.147])
        by mail02.iobjects.de (Postfix) with ESMTPSA id F15AB4164D32
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 18:07:56 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id 5174F825D3D
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Dec 2017 18:07:56 +0100 (CET)
Subject: Re: WARNING: CPU: 1 PID: 3016 at fs/btrfs/ctree.h:1564
 btrfs_update_device+0x189/0x190 [btrfs]
To: linux-btrfs@vger.kernel.org
References: <20171229163312.b3k7rfagcycz5mvf@galadriel.home.lxtec.de>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <0a34347a-ae74-dbab-98bd-08d822347c9b@applied-asynchrony.com>
Date: Fri, 29 Dec 2017 18:07:56 +0100
MIME-Version: 1.0
In-Reply-To: <20171229163312.b3k7rfagcycz5mvf@galadriel.home.lxtec.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Apply the patch from https://patchwork.kernel.org/patch/9960893/
and follow the logged instructions re. device resizing (or see
https://bugzilla.kernel.org/show_bug.cgi?id=196949 for examples).

The patch is unfortunately not yet merged into 4.15rc, otherwise it
could be sent to 4.14-stable.

-h

