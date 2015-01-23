Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.commandict.com.au ([203.190.234.55]:48063 "EHLO
	mascot.commandict.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbbAWHxq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Jan 2015 02:53:46 -0500
Received: from mascot.commandict.com.au (localhost [IPv6:::1])
	by mascot.commandict.com.au (Postfix) with ESMTP id DA49280225
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Jan 2015 18:53:42 +1100 (AEDT)
Subject: Recovery Operation With Multiple Devices
From: =?utf-8?Q?Brett_King?= <brett.king@commandict.com.au>
To: =?utf-8?Q?linux-btrfs=40vger=2Ekernel=2Eorg?=
	<linux-btrfs@vger.kernel.org>
Date: Fri, 23 Jan 2015 18:53:42 +1100
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <zarafa.54c1fe06.4689.28909bac67ef9272@mascot.commandict.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,
Just wondering how 'btrfs recovery' operates, when the source device given is one of many in an MD array - I can't find anything documentation beyond a single device use case.

Does it automatically include all devices in the relevant MD array as occurs when mounting, or does it only restore the data which happened to be written to the specific, single device given ?

>From an inverse perspective, how can I restore all data including snapshots, which are spread across a damaged MD FS to a new (MD) FS ?

Can send / receive do this perhaps ?

Thanks in advance !
