Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 189-19-234-109.dsl.telesp.net.br ([189.19.234.109]:34931 "EHLO
	anthem.async.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750790AbbAINtL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jan 2015 08:49:11 -0500
Date: Fri, 9 Jan 2015 11:48:53 -0200
From: Christian Robottom Reis <kiko@async.com.br>
To: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: make btrfs qgroups show human readable sizes
Message-ID: <20150109134853.GE15920@async.com.br>
References: <1420786025-7361-1-git-send-email-fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1420786025-7361-1-git-send-email-fancn.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 09, 2015 at 02:47:05PM +0800, Fan Chengniang wrote:
> make btrfs qgroups show human readable sizes, using -h option, example:

Oh! This is really nice. I wonder, would there be a sane way to show the
actual path the qgroup is associated with as well?
