Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from henninger.io ([144.76.155.217]:43080 "EHLO mail.henninger.io"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756952AbbJ3KXR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Oct 2015 06:23:17 -0400
Received: from [IPv6:2003:66:8a32:5500:29a4:ec31:e8e8:7fec] (p200300668A32550029A4EC31E8E87FEC.dip0.t-ipconnect.de [IPv6:2003:66:8a32:5500:29a4:ec31:e8e8:7fec])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.henninger.io (Postfix) with ESMTPSA id D9B2C460D20
	for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2015 11:23:14 +0100 (CET)
Subject: Re: [3/3] btrfs: qgroup: Fix a rebase bug which will cause qgroup
 double free
To: linux-btrfs@vger.kernel.org
References: <1445839879-17716-4-git-send-email-quwenruo@cn.fujitsu.com>
 <5631FE71.9090108@henninger.io>
From: Johannes Henninger <johannes+btrfs@henninger.io>
Message-ID: <56334512.2060009@henninger.io>
Date: Fri, 30 Oct 2015 11:23:14 +0100
MIME-Version: 1.0
In-Reply-To: <5631FE71.9090108@henninger.io>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Woops, just noticed I copied and pasted a typo there. Sorry for the
trouble. It should be:

Tested-by: Johannes Henninger <johannes+btrfs@henninger.io>
