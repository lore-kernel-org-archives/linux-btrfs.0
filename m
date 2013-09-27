Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f49.google.com ([209.85.128.49]:42407 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3I0PKD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 11:10:03 -0400
Received: by mail-qe0-f49.google.com with SMTP id s14so1894307qeb.22
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Sep 2013 08:10:03 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 27 Sep 2013 12:10:03 -0300
Message-ID: <CAOPVPepnhLQo+EG_vhGMsCHCd7p4G7HGYe16Ctmz23O61TPoUg@mail.gmail.com>
Subject: compression via chattr
From: William Lima <wlima@primate.com.br>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Enabling compression via chattr +c works with ZLIB (default method)
only, right? Since there is no way to specify a compression method.
Cannot I use LZO this way?

Thanks in advance,

-- 
w
