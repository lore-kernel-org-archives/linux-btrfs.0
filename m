Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:56158 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab3G3MZh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 08:25:37 -0400
Date: Tue, 30 Jul 2013 19:25:25 +0700
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs qgroup assign -> "ERROR: bad relation requested"
Message-ID: <20130730192525.42725e74@wpkg.org>
In-Reply-To: <8C42FC74-384A-4D88-9D11-17AC7394A20B@gmail.com>
References: <20130728135116.5ed992d4@wpkg.org>
	<8C42FC74-384A-4D88-9D11-17AC7394A20B@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 28 Jul 2013 15:36:41 +0800
Wang Shilong <wangshilong1991@gmail.com> wrote:

> Btrfs group assign requires parent's level > children's level, For
> your example below, you can do like:
> 
> btrfs qgroup create 1/1 <mnt>
> btrfs qgroup assign  1177 1/1 <mnt>
> btrfs qgroup assign  1178 1/1  <mnt>

Cool, thanks.

And is it possible (i.e. at some later point) to verify that 1177, 1178
were assigned to 1/1 (or in general, what is assigned to 1/1)?


-- 
Tomasz Chmielewski
http://wpkg.org

