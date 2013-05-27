Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33026 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab3E0WBJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 May 2013 18:01:09 -0400
Received: by mail-ee0-f46.google.com with SMTP id e49so4123395eek.5
        for <linux-btrfs@vger.kernel.org>; Mon, 27 May 2013 15:01:08 -0700 (PDT)
Received: from linux-suse.localnet (dsl51B6D2E0.pool.t-online.hu. [81.182.210.224])
        by mx.google.com with ESMTPSA id c5sm28488941eeu.8.2013.05.27.15.01.06
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 27 May 2013 15:01:07 -0700 (PDT)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: systemd "journalctl" is 1.89sec on ext4, 1.49 min on btrfs
Date: Tue, 28 May 2013 00:00:46 +0200
Message-ID: <4929941.8HmMn0JLJ4@linux-suse>
In-Reply-To: <20130527204723.573c4e3f@sf>
References: <16735484.PAleCPYpY8@noname> <20130527204723.573c4e3f@sf>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you very much for you suggestions!

I ran `filefrag` on /var/log/journal/ and the most fragmented files were:
/var/log/journal/[...]/faa9e41c6.journal: 11136 extents found
/var/log/journal/[...]/e9f8e1346c.journal: 633 extents found
/var/log/journal/[...]/59ec50b631.journal: 3585 extents found
/var/log/journal/[...]/59ec51d1b4.journal: 710 extents found
/var/log/journal/[...]/f74afadee9.journal: 484 extents found

Then I ran `btrfs fi defrag -v -f -clzo *` in the aforementioned directory 
three times and restarted the machine. Now, the `journalctl -b --no-pager` 
command runs in less than two seconds.

I tried to further optimize my file system (MySQL big storage files are highly 
affected), but somewhere (for me it looks like, on random places) there are 
kernel errors, so I suspended the further defragmentation until those errors 
are tracked down.

Thank you very much again.

Ákos
