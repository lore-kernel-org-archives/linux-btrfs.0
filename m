Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:43763 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932446AbdIHSJ5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Sep 2017 14:09:57 -0400
Received: by mail-wm0-f49.google.com with SMTP id f145so7795606wme.0
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Sep 2017 11:09:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170908163939.GS31874@twin.jikos.cz>
References: <20170908085446.GA7876@rus.uni-stuttgart.de> <20170908131035.GO31874@twin.jikos.cz>
 <CABB28Cz6wb0gvFF3sAUG5fw2JfgiB3KGGKfzOwAW0_2xBRcEFQ@mail.gmail.com>
 <20170908153816.GD23980@carfax.org.uk> <20170908163939.GS31874@twin.jikos.cz>
From: =?UTF-8?Q?Tomasz_K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Date: Fri, 8 Sep 2017 19:09:55 +0100
Message-ID: <CABB28CzBPffVMr5LW3x6Fhsj854X-=9h3H6uQ_fbVGy+TMh-jg@mail.gmail.com>
Subject: Re: test if a subvolume is a snapshot?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8 September 2017 at 17:39, David Sterba <dsterba@suse.cz> wrote:
[..]
> My plan is to introduce a global options to set various this, also the
> output format, eg.
>
>  $ btrfs -t bell be om -format=json subvolume list
>
> that would dump the list in json obviously, more formats could follow.
> This requires to switch all printf to a wrapper that would select the
> format based on global config. Some of the code is there, eg. the global
> option parser and the config structure. The printf transitions can be
> done incrementally. All of that is easy IMHO, somebody just needs to do
> it. I work on that when there are no other more pressing things to do.

What in the future json will be abandoned and some new/fancy parseable
output will be most desirable?
Hmm ??
Seems some people never saw or already forgot some old jokes.
http://www.webaugur.com/bazaar/53-what-if-operating-systems-were-airlines.html

"Unix Airlines

Each passenger brings a piece of the airplane and a box of tools to
the airport. They gather on the tarmac*, arguing constantly about what
kind of plane they want to build and how to put it together.
Eventually, *they build several different aircraft*, but give them all
the same name. Some passengers actually *reach their destination*"

So how to apply above to generate json output out of simple list? Try
below command on your linux:

$ awk 'BEGIN {print "{\"data\":["; ORS=""} {if (NR!=1) {print ",\n"};
print "{\"{#DISK}\":\"" $3 "\"}"} END {print "\n]}\n"}'
/proc/diskstats

***This is why no one is asking to transform Linux kernel procfs to
provide json output** as standard or an option.
(try to think few seconds on this)

As long as something is able to produce list with comma or spaces
separated fields to process such list and provide some usable json
output you need only:

$  (echo "foo:foo"; echo "bar:bar") | awk -F: 'BEGIN {print
"{\"data\":["; ORS=""} {if (NR!=1) {print ",\n"}; print
"{\"{#FOO}\":{\""$1"\",\""$2"\"}}"} END {print "\n]}\n"}'
{"data":[
{"{#FOO}":{"foo","foo"}},
{"{#FOO}":{"bar","bar"}}
]}

If you don't like awk you can use jq, sed, perl, python, ruby or
whatever you have/like/want.
However on writing fs tools all what you really *must do* is define
*as simple as it is only possible >stable< interface*.
Only this and nothing more.

Really on writing something so simple like fs tools you don't need to
think about future possibility to solve problem of famine on Earth
(using your code).

kloczek
