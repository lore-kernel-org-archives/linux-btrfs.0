Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51073 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab2KMKwn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Nov 2012 05:52:43 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so3895582eek.19
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Nov 2012 02:52:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGnBOw-58=g4pZcKC9GYBBJtpaOC_sj2mmQpNS+J6JR9+AY9YQ@mail.gmail.com>
References: <CAGnBOw-58=g4pZcKC9GYBBJtpaOC_sj2mmQpNS+J6JR9+AY9YQ@mail.gmail.com>
Date: Tue, 13 Nov 2012 18:52:42 +0800
Message-ID: <CAGnBOw-qpoydiEpgX0dBSh5xdkpZb3HGTMnMO0uYKFL596dM+A@mail.gmail.com>
Subject: Mixed RAID 1 and 0 in different subvolumes (cont.)
From: Fred Chang <fredchang@qnap.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Assume I have two disks, said disk1 and disk2, and two subvolumes,
said sv1 and sv2. With BTRFS, may I assign sv1 working with raid0 and
sv2 working with raid1?

One year ago, this function was not aviliable. If there were test
version, I am willing to test it.

Thanks
