Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:44679 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbdIKMom (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Sep 2017 08:44:42 -0400
Received: by mail-it0-f53.google.com with SMTP id r131so6873135itc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Sep 2017 05:44:42 -0700 (PDT)
Subject: Re: test if a subvolume is a snapshot?
To: =?UTF-8?Q?Tomasz_K=c5=82oczko?= <kloczko.tomasz@gmail.com>
Cc: linux-btrfs@vger.kernel.org
References: <20170908085446.GA7876@rus.uni-stuttgart.de>
 <20170908131035.GO31874@twin.jikos.cz>
 <CABB28Cz6wb0gvFF3sAUG5fw2JfgiB3KGGKfzOwAW0_2xBRcEFQ@mail.gmail.com>
 <20170908153816.GD23980@carfax.org.uk> <20170908163939.GS31874@twin.jikos.cz>
 <CABB28CzBPffVMr5LW3x6Fhsj854X-=9h3H6uQ_fbVGy+TMh-jg@mail.gmail.com>
 <f6cdd705-49a0-5a1a-da24-4b28fa13ac46@gmail.com>
 <CABB28Cxf42y7DfHQ-WK381qyEZsQ4Coe3g_=WfFeN5MgGYmVaQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0aec5bfd-fe7b-c87f-4905-f5093bb39ce6@gmail.com>
Date: Mon, 11 Sep 2017 08:44:35 -0400
MIME-Version: 1.0
In-Reply-To: <CABB28Cxf42y7DfHQ-WK381qyEZsQ4Coe3g_=WfFeN5MgGYmVaQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-08 16:54, Tomasz Kłoczko wrote:
> On 8 September 2017 at 20:06, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
> [..]
>>> If you don't like awk you can use jq, sed, perl, python, ruby or
>>> whatever you have/like/want.
>>
>> And which command is more readable?  Something like the above, or:
>> btrfs device stats --format=json /
> 
> How many people you know who are communicating in json or using comma
> separated lines of text?
Directly between people?  Probably none other than CS students and 
developers.  JSON is one of the few reliably unambiguous ways of 
representing tables of data in a language agnostic manner while still 
having them be easily machine parseable (and in fact, many programming 
languages use a similar format for defining tables).

Indirectly between people?  Tens of millions at least.  At minimum, 
almost everyone who uses social media is using JSON.

When dealing with administering a computer?  No idea, but at least as 
many people as use LVM and a number of widely used web application 
frameworks (and web applications built from them).  There is quite a lot 
of software that uses JSON files for configuration because it's easy to 
parse and also pretty trivial for most people to understand (and allows 
for certain particularly useful things that the INI format doesn't).

> Maybe it is not obvious but such interface is not for the humans.
But the code communicating using those formats _is_ for humans.  One of 
the most basic rules of software development is to write code that is 
easily maintainable, which in turn means easily readable.  My comment on 
readability was not about the output, but about the means of generating 
that output, which humans (more specifically, programmers) _do_ care about.

Put slightly differently, here's a comparison of getting info about 
device error counters in Python with and without JSON support in 
btrfs-progs:

Without JSON support (and without any error handling:
```
import subprocess

raw = subprocess.check_output([
           '/sbin/btrfs',
           'device',
           'stats',
           '/'
       ])
raw = stats.splitlines()
stats = dict()
for i in range(0, len(raw)):
     line = raw[i].split()
     value = int(line[1])
     device = line[0].split('.')[0].lstrip('[').rstrip(']')
     counter = line[0].split('.')[1]
     if not device in stats.keys():
         stats[device] = dict()
     stats[device][counter] = value
```

With JSON support in btrfs-progs (and also without error handling):
```
import subprocess
import json

raw = subprocess.check_output([
           '/sbin/btrfs',
           'device',
           'stats',
           '--format=json',
           '/'
       ])
stats = json.loads(raw)
```

Notice that the second form is exponentially easier to follow (assuming 
you already know that json.loads() parses a string as JSON, but if 
you're working with Python you probably already know that), and will 
probably run faster too.
