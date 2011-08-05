From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [RFC] btrfs send and receive
Date: Fri, 05 Aug 2011 13:24:55 +0200
Message-ID: <4E3BD307.3060205@jan-o-sch.net>
References: <4E369A80.9030307@jan-o-sch.net> <4E36F5B8.5090803@libero.it> <4E37C6CB.1030201@jan-o-sch.net> <1312298057-sup-3959@shiny> <4E381F70.4080102@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Goffredo Baroncelli <kreijack@libero.it>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E381F70.4080102@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 02.08.2011 18:01, Jan Schmidt wrote:
> On 02.08.2011 17:21, Chris Mason wrote:
>> But, I'll toss in an alternative.  Adapt the git pack files a little and
>> use them as the format.  There are a few reasons for this:
>>
>> Git has a very strong developer community and is already being
>> hammered into use as a backup application.  You'll find a lot of
>> interested people to help out.
>>
>> Git separates the contents from the metadata (names).  This makes it
>> naturally suited to describing snapshots and other features.  The big
>> exception is in large file handling, but you could extend the format to
>> describe filename,offset,len->sha instead of just filename->sha.
> 
> That sounds interesting. I haven't thought of git until now. It will
> lack the appealing feature to unpack without any special tools or a
> modified git client, I think. But I believe there are things that would
> get easier compared to pax.

There are easier questions to google. You'll find a lot of backup
applications having a git repository for maintaining their source code.
You'll find a lot of "linuxquestions.org * of the year" hits - because
in the news the versioning system of the year (git, of course) comes
right before the backup application of the year. And you'll also find
this thread in the top 10 or top 20 hits, depending on your search.

Using git as a backend for backups has been discussed earlier on the git
mailing list [1], though this rfc got no comments at all and development
apparently stopped after the initial post. This one [2] got a lot more
discussion, but keeps focused on text file (/etc dir). It may have made
the base for etc-keeper [3], aiming at the same target, but I did not
check that.

lwn.net discusses bup [4], which is mentioned several times on the git
mailing list, too. It's an actively developed backup tool writing its
own git files, including files's meta data. It is a collection of python
scripts calling git helper functions (namely git config, init, cat-file,
verify-pack, show-ref, rev-list and update-ref). I did not look deeper
as I'm for a C-only solution.

There is coldstorage [5] that has been stuck in a seemingly early phase
for more than a year.

Goffredo suggested looking at fast-import/export format [6], which I
did. It is a text based protocol, used to transport commits and
associated meta information from one VCS to another (possibly of a
different kind). My conclusion is that it's not suitable for solving the
problems being discussed here.

> I'll try to make a plan how it could be implemented with git, so that we
> have something we can compare.

Finally, we'll have to create a solution on our own. We could borrow
some ideas from bup if we decided to do it. We'd need a concept to store
more (arbitrary) meta data in the index, which would not be too hard to
add. And the content-addressed concept of git certainly has charme.

Although this inherent deduplication comes for free, we cannot save any
work on stream creation: As a bit of meta information, we will still
need to tell plain copies from reflinks, which could be stored in the
index. However, once we've figured out that something is referencing the
same data, we can use it to not store data multiple times in pax format,
too.

>> This doesn't mean I'll reject a pax setup, it's just an alternative to
>> think about.

After having done so, I'd like to say it's good that you don't reject
pax :-) It is definitely possible to use git's object store methods for
our stream format, but for me, pax still wins. Step by step:

On the plus side of git, I currently only have deduplication in our
stream format - for files that share content blocks (in the size of
blocks we would store). This can make the stream a little smaller,
however, as the content blocks get smaller in size (making dedup more
likely), meta data overhead increases.

On the plus side of pax, there is the possibility to create streams in
compatibility mode, making it possible to unpack them with any
(sufficiently recent) tar program. This advantage is such a big one, I
would put a good amount of extra work into it - which is not even necessary.

So, I'll not hard wire the stream output format and make it easily
replaceable. If no more facts come up here, I'll make my proof of
concept implementation with pax as stream format.

Thanks!
-Jan


[1] http://kerneltrap.org/mailarchive/git/2006/2/21/201380/thread#mid-201380
[2] http://thread.gmane.org/gmane.comp.version-control.git/33887
[3] http://kitenet.net/~joey/code/etckeeper/
[4] http://lwn.net/Articles/380983/
[5]
http://amarok.kde.org/blog/archives/1151-ColdStorage-A-Backup-Tool-Using-Git-At-Its-Core.html
[6] http://www.kernel.org/pub/software/scm/git/docs/git-fast-import.html
