Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.13]:56478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159AbaCORr4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 13:47:56 -0400
Message-ID: <53249245.4050007@friedels.name>
Date: Sat, 15 Mar 2014 18:47:49 +0100
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: Michael Schuerig <michael.lists@schuerig.de>, linux-btrfs@vger.kernel.org
Subject: Re: Snapper on Ubuntu
References: <53245E22.1060407@friedels.name> <12151050.DOANbtdZpp@fuchsia>
In-Reply-To: <12151050.DOANbtdZpp@fuchsia>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I think you may have forgotten to specify the config snapper is supposed
> to use. Try
>
> # snapper -c home create
> # snapper -c Video create

Thanks, that was it. I would have expected an Error-Message though...

Greetings,
Hendrik
