Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:32994 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbcG0Bvl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 21:51:41 -0400
Received: by mail-qk0-f171.google.com with SMTP id p74so22587220qka.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jul 2016 18:51:41 -0700 (PDT)
MIME-Version: 1.0
From: john gong <johngong0791@gmail.com>
Date: Wed, 27 Jul 2016 09:51:40 +0800
Message-ID: <CAEg8mkzkstRBSxKWkwXc9_Fmi5AnbnNd1UrUmvrQLPZv4Mnecg@mail.gmail.com>
Subject: perhaps a error in setup_root_args func
To: Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi All,

In func setup_root_args in fs/btrfs/super.c:
    while (1) {
        sep = strchrnul(args, ',');
        if (!strstarts(args, "subvol=") &&
            !strstarts(args, "subvolid=")) {

I think it should be:
    while (1) {
        sep = strchrnul(args, ',');
        if (!strstarts(args, "subvol=") || <- CHANGE
            !strstarts(args, "subvolid=")) {

Am i right?
I am on linus tree, have not check the btrfs tree cause the code is
being download.

B.R.

JohnGong
