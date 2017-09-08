Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47432 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756294AbdIHSpg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 14:45:36 -0400
Date: Fri, 8 Sep 2017 20:44:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: test if a subvolume is a snapshot?
Message-ID: <20170908184407.GV31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170908085446.GA7876@rus.uni-stuttgart.de>
 <20170908131035.GO31874@twin.jikos.cz>
 <CABB28Cz6wb0gvFF3sAUG5fw2JfgiB3KGGKfzOwAW0_2xBRcEFQ@mail.gmail.com>
 <20170908153816.GD23980@carfax.org.uk>
 <20170908163939.GS31874@twin.jikos.cz>
 <CABB28CzBPffVMr5LW3x6Fhsj854X-=9h3H6uQ_fbVGy+TMh-jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CABB28CzBPffVMr5LW3x6Fhsj854X-=9h3H6uQ_fbVGy+TMh-jg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 08, 2017 at 07:09:55PM +0100, Tomasz Kłoczko wrote:
> On 8 September 2017 at 17:39, David Sterba <dsterba@suse.cz> wrote:
> [..]
> > My plan is to introduce a global options to set various this, also the
> > output format, eg.
> >
> >  $ btrfs -t bell be om -format=json subvolume list
> >
> > that would dump the list in json obviously, more formats could follow.
> > This requires to switch all printf to a wrapper that would select the
> > format based on global config. Some of the code is there, eg. the global
> > option parser and the config structure. The printf transitions can be
> > done incrementally. All of that is easy IMHO, somebody just needs to do
> > it. I work on that when there are no other more pressing things to do.
> 
> What in the future json will be abandoned and some new/fancy parseable
> output will be most desirable?
> Hmm ??

Then we'll add a new format of the day to --format=yaml, as far as
possible we'll use existing code infrastructure, ie. there will be no
changes on the string emmiting side, we'll just change the "backend".

Json was an example because it's available in the util-linux and this is
also output style and capabilities I'm most likely going to copy (see
eg. lsblk --help). There's plain ascii, list, json outputs, or column
selection, sorting. The global option namespace in 'btrfs' is completely
empty now, so we can add one letter options.

> Seems some people never saw or already forgot some old jokes.
> http://www.webaugur.com/bazaar/53-what-if-operating-systems-were-airlines.html
> 
> "Unix Airlines
> 
> Each passenger brings a piece of the airplane and a box of tools to
> the airport. They gather on the tarmac*, arguing constantly about what
> kind of plane they want to build and how to put it together.
> Eventually, *they build several different aircraft*, but give them all
> the same name. Some passengers actually *reach their destination*"
> 
> So how to apply above to generate json output out of simple list? Try
> below command on your linux:
> 
> $ awk 'BEGIN {print "{\"data\":["; ORS=""} {if (NR!=1) {print ",\n"};
> print "{\"{#DISK}\":\"" $3 "\"}"} END {print "\n]}\n"}'
> /proc/diskstats
> 
> ***This is why no one is asking to transform Linux kernel procfs to
> provide json output** as standard or an option.
> (try to think few seconds on this)
> 
> As long as something is able to produce list with comma or spaces
> separated fields to process such list and provide some usable json
> output you need only:
> 
> $  (echo "foo:foo"; echo "bar:bar") | awk -F: 'BEGIN {print
> "{\"data\":["; ORS=""} {if (NR!=1) {print ",\n"}; print
> "{\"{#FOO}\":{\""$1"\",\""$2"\"}}"} END {print "\n]}\n"}'
> {"data":[
> {"{#FOO}":{"foo","foo"}},
> {"{#FOO}":{"bar","bar"}}
> ]}
> 
> If you don't like awk you can use jq, sed, perl, python, ruby or
> whatever you have/like/want.
> However on writing fs tools all what you really *must do* is define
> *as simple as it is only possible >stable< interface*.
> Only this and nothing more.

The tools' output could consumed by humans and scripts, so the idea is
to make the defaults human readlabe but provide a simple (as a
commandline option) way for scripts to parse just the data.

The libsmartcols that provides the columns and output formatting for
util-linux is rich enough to get the same or very similaro output you
get by the awk script above. And that's not supposed to be the only way.
Say I ask the tool to give me all data it has and parse it in the
script.

Stability of the output is a nice goal, hard to achieve in practice. We
dont't know the future needs but can't freeze the output forever. The
scripting tools you mention are powerful and no fancy formatting we
could add to btrfs will replace them. So if there's a terse plain text
output, the chances are high that script writer will be able to get the
information he wants.

I don't disagree with you and don't see what else is there to argue
about.
