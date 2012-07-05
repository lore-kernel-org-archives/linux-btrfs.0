Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 50-193-208-193-static.hfc.comcastbusiness.net ([50.193.208.193]:52207
	"EHLO tetsuo.zabbo.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab2GEShl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jul 2012 14:37:41 -0400
Message-ID: <4FF5DEF4.3060104@zabbo.net>
Date: Thu, 05 Jul 2012 11:37:40 -0700
From: Zach Brown <zab@zabbo.net>
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>
CC: Alexander Block <ablock84@googlemail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 4/7] Btrfs: introduce subvol uuids and times
References: <1341409108-13567-1-git-send-email-ablock84@googlemail.com> <1341409108-13567-5-git-send-email-ablock84@googlemail.com> <4FF5C9F2.903@zabbo.net> <CAB9VWqAoKXCU4T93_aMSC_2rgcQT7MVWVVaVPMhvHrG7sDVStQ@mail.gmail.com> <4FF5CCD0.5000107@zabbo.net> <20120705183343.GA5403@zambezi.lan>
In-Reply-To: <20120705183343.GA5403@zambezi.lan>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> and take endianess into account with le{64,32}_to_cpu and
> cpu_to_le{64,32} macros.

The kernel doesn't support system calls from userspace of a different
endianness, no worries there :)

- z
