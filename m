Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33115 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbcEPXIe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 19:08:34 -0400
Received: by mail-oi0-f68.google.com with SMTP id t140so19835212oie.0
        for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2016 16:08:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTqmqg5tMGbLU9NV57s92JebCjT_4DFzRP613ZtXQ=Uiw@mail.gmail.com>
References: <CAJCQCtTqmqg5tMGbLU9NV57s92JebCjT_4DFzRP613ZtXQ=Uiw@mail.gmail.com>
Date: Mon, 16 May 2016 17:08:33 -0600
Message-ID: <CAJCQCtTmf9eMKJkLvJaMh+=-is_WkEut-KdAVC+5yyuroO=o_g@mail.gmail.com>
Subject: Re: corrupt node with extent csum item results in bogus data being read
From: Chris Murphy <lists@colorremedies.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I realized this could be a much bigger problem for single copy
metadata on SSD case, rather than the example using raid1 where it's
unlikely for both copies of the node to be corrupt. So I filed a bug.

https://bugzilla.kernel.org/show_bug.cgi?id=118321
