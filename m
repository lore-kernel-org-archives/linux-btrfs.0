From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: efficiency of btrfs cow
Date: Sun, 6 Mar 2011 09:22:00 -0800
Message-ID: <AANLkTikjdi+Qo_AhsGgOquDQoy+EzZ0BoiMj9aUb_zCQ@mail.gmail.com>
References: <il0a8d$4ev$1@dough.gmane.org>
	<AANLkTi=-bxNwFmp8GZ_Foz=CSP2kUOwqPKAaMFapGuz+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Brian J. Murrell" <brian@interlinx.bc.ca>,
	linux-btrfs@vger.kernel.org
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=-bxNwFmp8GZ_Foz=CSP2kUOwqPKAaMFapGuz+@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 6, 2011 at 8:02 AM, Fajar A. Nugraha <list@fajar.net> wrote:
> On Sun, Mar 6, 2011 at 10:46 PM, Brian J. Murrell <brian@interlinx.bc.ca> wrote:
>> # cp -al /backup/previous-backup/ /backup/current-backup
>> # rsync -aAHX ... --exclude /backup / /backup/current-backup
>>
>> The shortcoming of this of course is that it just takes 1 byte in a
>> (possibly huge) file to require that the whole file be recopied to the
>> backup.
>
> If you have snapshots anyway, why not :
> - create a snapshot before each backup run
> - use the same directory (e.g. just /backup), no need to "cp" anything
> - add "--inplace" to rsync

You may also want to test with/without --no-whole-file as well.
That's most useful when the two filesystems are on the same system and
should reduce the amount of data copied around, as it forces rsync to
only use file deltas.  This is very much a win on ZFS, which is also
CoW, so it should be a win on Btrfs.


-- 
Freddie Cash
fjwcash@gmail.com
