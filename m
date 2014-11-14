Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from phd-imap.ethz.ch ([129.132.80.51]:58893 "EHLO phd-imap.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964931AbaKNSXD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 13:23:03 -0500
Message-ID: <54664884.9010307@phys.ethz.ch>
Date: Fri, 14 Nov 2014 19:23:00 +0100
From: Patrick Schmid <schmid@phys.ethz.ch>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: soft lockup - CPU#0 stuck - Kernel 3.17.2
References: <5464B2DB.7070008@phys.ethz.ch>	<1415890157.25389.3@mail.thefacebook.com> <54650166.1090800@phys.ethz.ch>	<1415905935.25389.4@mail.thefacebook.com> <54659FDB.6070300@phys.ethz.ch> <1415986775.25389.10@mail.thefacebook.com>
In-Reply-To: <1415986775.25389.10@mail.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> What kind of machine is this?  I'm trying to reproduce here.

The "frontend" hardware is a 24 core Xeon E5-2620 on an Intel S2600GZ 
board with 128 GiB RAM, the nic is a Intel X520-DA2 10Gb/s SFP+, running 
Ubuntu 14.04LTS.

Do you need more infos?

Patrick
