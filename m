Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:50415 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750785AbdITEGJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 00:06:09 -0400
Received: by mail-lf0-f47.google.com with SMTP id d4so1457623lfj.7
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 21:06:08 -0700 (PDT)
Subject: Re: difference between -c and -p for send-receive?
To: Dave <davestechshop@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAH=dxU5NfenfKfsuXuZ8uBYKBb5a0VOEqan6taAwZTT0oM8xcQ@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <5d7494af-0d18-8663-57a5-3007252fa0e3@gmail.com>
Date: Wed, 20 Sep 2017 07:06:05 +0300
MIME-Version: 1.0
In-Reply-To: <CAH=dxU5NfenfKfsuXuZ8uBYKBb5a0VOEqan6taAwZTT0oM8xcQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

19.09.2017 03:41, Dave пишет:
> new subject for new question
> 
> On Mon, Sep 18, 2017 at 1:37 PM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 
>>>> What scenarios can lead to "ERROR: parent determination failed"?
>>>
>>> The man page for btrfs-send is reasonably clear on the requirements
>>> btrfs imposes. If you want to use incremental sends (i.e. the -c or -p
>>> options) then the specified snapshots must exist on both the source and
>>> destination. If you don't have a suitable existing snapshot then don't
>>> use -c or -p and just do a full send.
>>>
>>
>> Well, I do not immediately see why -c must imply incremental send. We
>> want to reduce amount of data that is transferred, so reuse data from
>> existing snapshots, but it is really orthogonal to whether we send full
>> subvolume or just changes since another snapshot.
>>
> 
> Starting months ago when I began using btrfs serious, I have been
> reading, rereading and trying to understand this:
> 
> FAQ - btrfs Wiki
> https://btrfs.wiki.kernel.org/index.php/FAQ#What_is_the_difference_between_-c_and_-p_in_send.3F
> 

This wiki entry is wrong (and as long as I can believe git, it has
always been wrong).

First, "btrfs send -c" does not start with blank subvolume; it starts
with "best parent" which is determined automatically. Actually if you
look at the help output in the very first version of send command:

        "By default, this will send the whole subvolume. To do",
        "an incremental send, one or multiple '-i <clone_source>'",
        "arguments have to be specified. A 'clone source' is",
        "a subvolume that is known to exist on the receiving",
        "side in exactly the same state as on the sending side.\n",
        "Normally, a good snapshot parent is searched automatically",
        "in the list of 'clone sources'. To override this, use",
        "'-p <parent>' to manually specify a snapshot parent.",

it explains fat better what -c and -p do (ignore -i, this is error that
was fixed later, it means -c).

Second, example in wiki simply does not work. All snapshots listed in -c
options and snapshot that we want to transfer must have the same parent
uuid, unless -p is explicitly provided. Example shows snapshots of two
different subvolumes. I could not make it work even if A and B
themselves are cloned from common subvolume.

