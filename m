Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35521 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbcFNXGt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 19:06:49 -0400
Received: by mail-wm0-f65.google.com with SMTP id k184so1838833wme.2
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 16:06:48 -0700 (PDT)
Received: from detritus (p4FDCC87F.dip0.t-ipconnect.de. [79.220.200.127])
        by smtp.gmail.com with ESMTPSA id d137sm6391646wmd.12.2016.06.14.16.06.46
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Jun 2016 16:06:47 -0700 (PDT)
Message-ID: <1465945606.18810.1.camel@googlemail.com>
Subject: Re: [PATCH] receive: strip root subvol path during process_clone
From: Benedikt Morbach <benedikt.morbach@googlemail.com>
To: linux-btrfs@vger.kernel.org
Date: Wed, 15 Jun 2016 01:06:46 +0200
In-Reply-To: <20160614225541.18140-1-benedikt.morbach@googlemail.com>
References: <20160614225541.18140-1-benedikt.morbach@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

this fixes http://thread.gmane.org/gmane.comp.file-systems.btrfs/56902 
for me.
I got to this via gdb + good old debug printf and tbh I'm not entirely
clear about the semantics of process_clone, so some error handling
might be missing here?

Cheers
Benedikt

