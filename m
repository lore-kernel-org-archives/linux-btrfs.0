Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f41.google.com ([209.85.213.41]:60687 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbbBAR5s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Feb 2015 12:57:48 -0500
Received: by mail-yh0-f41.google.com with SMTP id f73so14339788yha.0
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Feb 2015 09:57:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422810946.4462.1.camel@miceliux.com>
References: <20150201121335.GA4599@pitr.home.jan>
	<1422810946.4462.1.camel@miceliux.com>
Date: Sun, 1 Feb 2015 10:57:47 -0700
Message-ID: <CAJCQCtR6RS1pQznKLwx9OvPL-mgVsGqhCDnmANAeDT454spMvA@mail.gmail.com>
Subject: Re: security.capability xattr missing after btrfs send/receive
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looks like security.capabilities also has tripped up tar.
https://bugzilla.redhat.com/show_bug.cgi?id=771927

There's a suggestion that security.capabilities are "non standard
attributes"? Also, comment 28 is interesting. Anyway it seems a big
messy to support them in any case.
