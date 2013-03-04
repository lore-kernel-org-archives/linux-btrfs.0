Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:39473 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab3CDSaX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 13:30:23 -0500
Received: from localhost (unknown [192.168.242.141])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by tetsuo.zabbo.net (Postfix) with ESMTPSA id 69B1B72001CE
	for <linux-btrfs@vger.kernel.org>; Mon,  4 Mar 2013 10:30:22 -0800 (PST)
Date: Mon, 4 Mar 2013 10:30:22 -0800
From: Zach Brown <zab@zabbo.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs fixup
Message-ID: <20130304183022.GZ1658@lenny.home.zabbo.net>
References: <20130303123249.GB18135@shiny.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130303123249.GB18135@shiny.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(dropping cc:s just to -btrfs)

> Geert and James both sent this one in, sorry guys.

FWIW, dhowells now packages cross gcc and binutils in fedora
specifically for cross kernel builds.

# yum list cross-{binutils,gcc}-common
cross-binutils-common.noarch          2.23.51.0.3-1.fc18 fedora
cross-gcc-common.noarch               4.7.1-0.1.20120606.fc18.1 fedora

- z
