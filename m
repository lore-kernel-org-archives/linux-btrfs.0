Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:38002 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaHKCxp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Aug 2014 22:53:45 -0400
Received: by mail-qg0-f50.google.com with SMTP id q108so8109294qgd.9
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Aug 2014 19:53:44 -0700 (PDT)
Message-ID: <53E83035.8010603@gmail.com>
Date: Sun, 10 Aug 2014 22:53:41 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Vimal A R <arvimal@yahoo.in>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Ideas for a feature implementation
References: <1407698476.20187.YahooMailNeo@web192906.mail.sg3.yahoo.com>
In-Reply-To: <1407698476.20187.YahooMailNeo@web192906.mail.sg3.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/10/2014 03:21 PM, Vimal A R wrote:
> Hello,
> 
> I came across the to-do list at https://btrfs.wiki.kernel.org/index.php/Project_ideas and would like to know if this list is updated and recent.
> 
> I am looking for a project idea for my under graduate degree which can be completed in around 3-4 months. Are there any suggestions and ideas to help me further?
> 
> Thank you,
> Vimal
It's not really listed there (though some of the projects there might be
considered subsets of it), but improved parallelization for the
multi-device setups is one thing that I know that a lot of people would
like to see.

Another thing that isn't listed there, that I would personally love to
see is support for secure file deletion.  To be truly secure though,
this would need to hook into the COW logic so that files marked for
secure deletion can't be reflinked (maybe make the automatically NOCOW
instead, and don't allow snapshots?), and when they get written to, the
blocks that get COW'ed have the old block overwritten.

