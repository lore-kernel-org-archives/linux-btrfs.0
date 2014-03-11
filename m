Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:50102 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbaCKAQ4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 20:16:56 -0400
Received: by mail-ig0-f171.google.com with SMTP id hl1so9818606igb.4
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Mar 2014 17:16:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <531E4A02.5010404@linux.intel.com>
References: <531E4A02.5010404@linux.intel.com>
Date: Mon, 10 Mar 2014 18:16:56 -0600
Message-ID: <CAE5mzvjmTFBM1Bpshsu8rfHNssnPAFZw+BompecoGG2GRnVwzg@mail.gmail.com>
Subject: Re: Building a brtfs filesystem < 70M?
From: cwillu <cwillu@cwillu.com>
To: Saul Wold <sgw@linux.intel.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Have you tried the -M option to mkfs.btrfs?  I'm not sure if we select
it automatically (or if we do, whether you have recent enough tools to
have that).
