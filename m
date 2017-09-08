Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:46917 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756777AbdIHTG5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Sep 2017 15:06:57 -0400
Received: by mail-it0-f45.google.com with SMTP id 6so3690156itl.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Sep 2017 12:06:57 -0700 (PDT)
Subject: Re: test if a subvolume is a snapshot?
To: =?UTF-8?Q?Tomasz_K=c5=82oczko?= <kloczko.tomasz@gmail.com>,
        linux-btrfs@vger.kernel.org
References: <20170908085446.GA7876@rus.uni-stuttgart.de>
 <20170908131035.GO31874@twin.jikos.cz>
 <CABB28Cz6wb0gvFF3sAUG5fw2JfgiB3KGGKfzOwAW0_2xBRcEFQ@mail.gmail.com>
 <20170908153816.GD23980@carfax.org.uk> <20170908163939.GS31874@twin.jikos.cz>
 <CABB28CzBPffVMr5LW3x6Fhsj854X-=9h3H6uQ_fbVGy+TMh-jg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f6cdd705-49a0-5a1a-da24-4b28fa13ac46@gmail.com>
Date: Fri, 8 Sep 2017 15:06:52 -0400
MIME-Version: 1.0
In-Reply-To: <CABB28CzBPffVMr5LW3x6Fhsj854X-=9h3H6uQ_fbVGy+TMh-jg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-08 14:09, Tomasz Kłoczko wrote:
> On 8 September 2017 at 17:39, David Sterba <dsterba@suse.cz> wrote:
> [..]
>> My plan is to introduce a global options to set various this, also the
>> output format, eg.
>>
>>   $ btrfs -t bell be om -format=json subvolume list
>>
>> that would dump the list in json obviously, more formats could follow.
>> This requires to switch all printf to a wrapper that would select the
>> format based on global config. Some of the code is there, eg. the global
>> option parser and the config structure. The printf transitions can be
>> done incrementally. All of that is easy IMHO, somebody just needs to do
>> it. I work on that when there are no other more pressing things to do.
> 
> What in the future json will be abandoned and some new/fancy parseable
> output will be most desirable?
> Hmm ??
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
No, the primary reason that nobody is asking to transform procfs to spit 
out JSON is that it's a pain to parse (in a shell, you need excessive 
stuff like the above command, in almost any other language you have to 
write a special parser or use a separate library) when compared to the 
simple space and newline delimited stuff already in proc (in Python for 
example, you just need str.split() and str.splitlines(), both of which 
are part of the core language), and it's insanely more efficient to just 
spit out the data as-is without all the extra stuff required by JSON 
(it's not as bad as XML, but it's still mostly pointless).  The only 
thing that adding JSON support would give people is a way to avoid 
having to use extra tools or kernel documentation to figure out what 
everything is, which is not seen as a significant benefit since almost 
nobody interacts directly with anything in /proc other than developers 
and people poking at sysctls.
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
And which command is more readable?  Something like the above, or:
btrfs device stats --format=json /

Almost anybody is going to say that the second case (with a simple 
option) is more readable, and it's also almost always going to be more 
efficient too since you don't have to fork() an extra time and deal with 
another pipe.  Even using the other tools you mentioned, none of them is 
going to be as trivially easy for people to understand what's going on 
as just having an extra option to control the output format.
> However on writing fs tools all what you really *must do* is define
> *as simple as it is only possible >stable< interface*.
> Only this and nothing more.
With the added constraint that your output should be self consistent and 
sensibly arranged.  The current output from various btrfs commands is 
designed to be human readable, and does not consistently conform to the 
same formatting.  It's also a serious pain to parse without using a 
language with proper string operations (take a look at the output of 
`btrfs device stats` for an example, it uses runs of spaces to separate 
and align fields, which is ridiculous to try and parse in a shell 
script), and the lack of a standard output format means that anything 
interacting with it is inherently fragile.
> 
> Really on writing something so simple like fs tools you don't need to
> think about future possibility to solve problem of famine on Earth
> (using your code).
This is a case though where having something that's more easily machine 
parseable is a significant benefit, because the command-line is the API 
unless you're willing to fight with ioctls.
