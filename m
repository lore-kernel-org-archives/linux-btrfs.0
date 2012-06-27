Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49610 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab2F0EZR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 00:25:17 -0400
Received: by wibhr14 with SMTP id hr14so583278wib.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 21:25:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAE6i0hxv2t0-df+JLtCTC7k8VKTuH-DkUQ7saOSGWSKEV7C2Q@mail.gmail.com>
References: <CAAE6i0jGqbOcRbhEYQiLdSUyxaKkFZKQTqb82shaSYdF9jFEqg@mail.gmail.com>
 <CAAE6i0jcfJvBq_JJhO-DVWqBrtEJe1nA7t8k-fqF0BtQY15N4w@mail.gmail.com> <CAAE6i0hxv2t0-df+JLtCTC7k8VKTuH-DkUQ7saOSGWSKEV7C2Q@mail.gmail.com>
From: Chester <somethingsome2000@gmail.com>
Date: Tue, 26 Jun 2012 23:24:56 -0500
Message-ID: <CAAE6i0i7etUgKgGEAzDR6BSruz4AWhaw-0_zvHxwqDAQnyBQ3g@mail.gmail.com>
Subject: Re: btrfs volume suddenly becomes read-only
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Problem still occurs.. With just a bittorrent client (downloading) +
chrome running.

This could also be related but, last night, I triggered a btrfs
balance.. I'm not too sure whether the balance finished or not,
because when I took a look at it this morning, it said "no file or
directory" and told me to check dmesg for messages. I did check, and I
saw the usual bunch of "moving block group" and "xxxx extents found"
messages that come from balances.
