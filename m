Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:33650 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3EET0l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 May 2013 15:26:41 -0400
Received: by mail-oa0-f54.google.com with SMTP id j1so2898865oag.41
        for <linux-btrfs@vger.kernel.org>; Sun, 05 May 2013 12:26:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <fthi5a-o7r.ln1@hurikhan.ath.cx>
References: <loom.20130503T133254-992@post.gmane.org> <fthi5a-o7r.ln1@hurikhan.ath.cx>
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Date: Sun, 5 May 2013 21:26:20 +0200
Message-ID: <CADn-QaP67AuMTpH2ax-cqYVOF3cNM326HWENYsaPKdO6zHeGMQ@mail.gmail.com>
Subject: Re: Script for creating/managing snapshots of all subvolumes of all filesystems
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

On Sun, May 5, 2013 at 7:36 PM, Kai Krakow <hurikhan77+btrfs@gmail.com> wrote:
> Alexander Skwar <alexanders.mailinglists+nospam@gmail.com> schrieb:
>
>> FWIW, I've also written a script which creates and "manages"
>> (ie. deletes old) snapshots.
>>
>> It figures out all the available filesystems and creates snaps
>> for all the available (sub)volumes.
>>
>> It's also on https://copy.com/WI9AXqTH2nD4 and
>> http://pastebin.com/YX8WKcsR to avoid line break issues and also with
>> comments.
>
> You should change the calls of "btrfs subv del" etc to use unabbreviated
> versions of the commands. Otherwise you expose your script to erratic

Oh, yes. Very good point. And there really isn't any benefit
in using abbreviated versions of the command names in a
script anyway.

On the command line: Yes, less to type = better.
But in a script?

Thanks. Very good point indeed!

Alexander
--
=>        Google+ => http://plus.skwar.me         <==
=> Chat (Jabber/Google Talk) => a.skwar@gmail.com <==
