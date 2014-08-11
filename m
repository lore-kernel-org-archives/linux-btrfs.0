Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:49446 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbaHKVdg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 17:33:36 -0400
Received: by mail-pd0-f176.google.com with SMTP id y10so11325199pdj.7
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Aug 2014 14:33:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <A7CFCD27-F663-425A-A695-3E7842777348@colorremedies.com>
References: <CAETJ_S-BOjatUFPVPwKCmgMRfWG6K0WEJgE=F_Di2i=52fqGCQ@mail.gmail.com>
	<2242759.aOKEuU2TTR@xev>
	<20140809143206.GJ11855@bitfolk.com>
	<CAETJ_S8rf4Y_7x4+fDB19JfNZYa1wjQOwTHcdCxd9eHq17NgXg@mail.gmail.com>
	<CAETJ_S-VZk5pxgT4HCJnQwenL6eDP88z7tW-KEHYqtnn=NWbww@mail.gmail.com>
	<pan$29b1$ee1dac$e6091513$d07b2702@cox.net>
	<CAETJ_S8347mtU6-o9BW=_Q27atdcj6P-aFZ1551S6G6rXBS8=A@mail.gmail.com>
	<CAETJ_S9HsWEYrV2zrfr8ZSD69SoFCiHnND38HLo8pq7ENiEPbw@mail.gmail.com>
	<CAETJ_S8DT=yW6V8bmAJ5s-+ZbuLjnDUK_XWEFRwK_p8hoR+LWA@mail.gmail.com>
	<pan$d6d2e$b19333f0$ee4ea84e$5a707866@cox.net>
	<A7CFCD27-F663-425A-A695-3E7842777348@colorremedies.com>
Date: Mon, 11 Aug 2014 16:33:36 -0500
Message-ID: <CAETJ_S_YDnJsf9Fc6+ynpBVK7MXv3RGuhhJrSVV2Tizf1J+kdA@mail.gmail.com>
Subject: Re: 40TB volume taking over 16 hours to mount, any ideas?
From: Jose Ildefonso Camargo Tolosa <ildefonso.camargo@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As I hate when a thread is left "hanging", you deserve to know what
happened in the end, you likely already guessed, but anyway: I nuked
the filesystem, and started over.

After some internal discussion in the company, we decided to move to
ZFS for now.  However, we will keep an eye on btrfs, and will likely
deploy it to some smaller system for further testing.

Thanks you all for your help!

Sincerely,

Ildefonso
