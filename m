Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654Ab3JKRgj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 13:36:39 -0400
Date: Fri, 11 Oct 2013 10:36:36 -0700
From: Zach Brown <zab@redhat.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: init device stats for new devices
Message-ID: <20131011173636.GT25712@lenny.home.zabbo.net>
References: <a1938a2cc8a66c24293b19aa91526d6eac433b10.1381497087.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a1938a2cc8a66c24293b19aa91526d6eac433b10.1381497087.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> a filesystem is mounted. They set the device stats to zero by using
> kzalloc() which is correct for new devices.

Oh, right, got it :)

- z
