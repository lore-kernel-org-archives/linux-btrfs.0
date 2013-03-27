Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:52342 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3C0VnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 17:43:08 -0400
Received: by mail-ee0-f52.google.com with SMTP id d17so1026173eek.39
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2013 14:43:07 -0700 (PDT)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug on mismatching generation_v2 in inode.c:835
Date: Wed, 27 Mar 2013 22:42:50 +0100
Message-ID: <1387808.en6n74oCv4@linux-suse>
In-Reply-To: <20130327205212.GM28030@localhost.localdomain>
References: <CAAr69zZ7OpGpT7qcKdWA0k_0MR-wbhd-+EFGBQ+TQ5CycM8GDg@mail.gmail.com> <CAAr69zaQ22_SLg4sfUkDE=NBNTAUaSr9ZgaL=sTPJ-kvXkFRug@mail.gmail.com> <20130327205212.GM28030@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I ran btrfsck three times and tried to restart the OS. After a generation_v2 
resetting it booted and now it works! :)

Thank you very much for your help!


Two btrfsck run was needed for the complete cleanup, but interestingly the end 
statistics were a little bit different each time.

Specifically, the values of
- total fs tree bytes: 2285948928
- total extent tree bytes: 303124480
- btree space waste bytes: 742282214
lines varied with each run, even if there were no need of repairing.

Ákos
