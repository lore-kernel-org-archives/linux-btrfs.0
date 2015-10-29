Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from henninger.io ([144.76.155.217]:40492 "EHLO mail.henninger.io"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbbJ2LJk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 07:09:40 -0400
Subject: Re: [3/3] btrfs: qgroup: Fix a rebase bug which will cause qgroup
 double free
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1445839879-17716-4-git-send-email-quwenruo@cn.fujitsu.com>
From: Johannes Henninger <johannes+btrfs@henninger.io>
Message-ID: <5631FE71.9090108@henninger.io>
Date: Thu, 29 Oct 2015 12:09:37 +0100
MIME-Version: 1.0
In-Reply-To: <1445839879-17716-4-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tested-by: Johannes Henninger <johannes+btrfs@henniger.io>
