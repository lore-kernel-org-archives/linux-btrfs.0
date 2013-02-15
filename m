Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35431 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3BOXjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Feb 2013 18:39:21 -0500
Received: by mail-wi0-f172.google.com with SMTP id ez12so1751232wid.5
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2013 15:39:20 -0800 (PST)
From: Diego Calleja <diegocg@gmail.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs-progs: add support for device replace procedure
Date: Sat, 16 Feb 2013 00:34:54 +0100
Message-ID: <2884358.Z9FbK9B16v@diego-arch>
In-Reply-To: <3344706e9c44b0dbfaf2e74aa60c1185fa193721.1355244128.git.sbehrens@giantdisaster.de>
References: <3344706e9c44b0dbfaf2e74aa60c1185fa193721.1355244128.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

El Martes, 11 de diciembre de 2012 17:50:00 Stefan Behrens escribió:
> This is the user mode part of the device replace patch series.
> 
> The command group "btrfs replace" is added with three commands:
> - btrfs replace start srcdev|srcdevid targetdev [-Bfr] mount_point
> - btrfs replace status mount_point [-1]
> - btrfs replace cancel mount_point

Wouldn't this be better placed under the "btrfs device" command group?
