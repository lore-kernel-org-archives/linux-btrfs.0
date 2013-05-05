Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f178.google.com ([209.85.210.178]:34888 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3EESxt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 May 2013 14:53:49 -0400
Received: by mail-ia0-f178.google.com with SMTP id t29so2710964iag.9
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 11:53:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAr69zYBpeJw-faQjdEXTgrsp3p0AN7i8CU+FJnyEjTb8n1GKg@mail.gmail.com>
References: <1420920.Yent3fKO0t@linux-suse> <20130326130111.GI1955@localhost.localdomain>
 <CAAr69zYBpeJw-faQjdEXTgrsp3p0AN7i8CU+FJnyEjTb8n1GKg@mail.gmail.com>
From: =?UTF-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
Date: Sun, 5 May 2013 18:53:28 +0000
Message-ID: <CAAr69zZYJbc7yt_2wbN1VmUgPPqvh+2bXm+_A+yQUNSgRC9VMA@mail.gmail.com>
Subject: Re: Kernel BUG on corrupted space cache under 3.7 and 3.8
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I could "successfully" reproduce this issue while I was upgrading from
3.8 to 3.9. All the symptoms are exactly the same as I've written a
month ago, nothing changed.
I'll send you the link to the corrupted image file in a private mail.

Btw, under Gentoo (SystemRescueCD to be precise) there are three
warning in the btrfs-progs: http://pastebin.com/rYam2jWb

Ákos
