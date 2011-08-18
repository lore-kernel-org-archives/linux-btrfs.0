From: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: [RFC] btrfs auto snapshot
Date: Thu, 18 Aug 2011 18:07:12 +0800
Message-ID: <4E4CE450.2000303@oracle.com>
References: <4E4B2452.9070407@oracle.com> <20110817133108.GA24578@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: "Matthias G. Eckermann" <mge@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110817133108.GA24578@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>



  Thanks MgE. snapper is cool, does most the stuff required here.

  however the challenging part will be to keep the number of tools
  (to manage btrfs) at a limit 1 or 2 max. (too many tools to manage
  btrfs is most likely to confuse).

Cheers, Anand

On 08/17/2011 09:31 PM, Matthias G. Eckermann wrote:
> Hello Anand and all,
>
> On 2011-08-17 T 10:15 +0800 Anand Jain wrote:
>
>>   Appears that no one is working on the auto-snapshot feature for
>>   btrfs, so here I am implementing the same.
>
> thanks for bringing this up! The group of features you are listing is
> indeed of high interest for people using btrfs.
>
> That said, not only have other people though about this, but a lot of
> your question already have been implemented in "snapper", and open
> source infrastructure developed as part of openSUSE and SUSE Linux
> Enterprise.
>
> Please see:
> 	http://en.opensuse.org/Portal:Snapper
> 	http://en.opensuse.org/openSUSE:Snapper_install
> 	http://lizards.opensuse.org/2011/04/01/introducing-snapper/
>
> Source code is here:
> 	http://gitorious.org/opensuse/snapper
>
> "snapper" will be part of openSUSE 12.1 and SUSE Linux Enterprise 11
> Service Pack 2, and is available as part of the respective Beta
> releases and Milestones already.
>
> snapper's concept in short:
> - shared library to make the functionality available to
>    other tools as well
> - libsnapper is implemented on top of the btrfsprogs
> - cmdline tool "snapper"
> - global configuration file
> 	/etc/sysconfig/snapper
> - one configuration file per subvolume to be snapshotted
> 	/etc/snapper/configs/<config-name>
>    I call this a "single configuration" going forward.
>    Here also policies for time based snapshotting and
>    cleanup are to be configured.
> - Integration into SUSE's management framework (YaST2/zypper),
>    however, "snapper" should work independent of those,
>    i.e. usable on other distributions easily.
>
>>   Below is a draft on the feature list.  Any comments / questions /
>>   suggestions are welcome, please do let me know.
>
> Let me go through the single features quickly and list the matching
> snapper functionality.
>
>>   btrfs auto snapshot feature will include:
>>   Initially:
>>       - configurable timely snapshots
>
> Yes. Configured per single configuration
>
>>       - uses services and crontab to schedule
>
> Yes.
>
>>       - Gnome integration
>
> I more see a need for integration into systems management frameworks.
>
>>       - snapshot rollback and cleanups
>
> Yes. Rules for cleanups (time based, number of snapshots)
> per single configuration.
>
>>       - snapshot trashing based on available space
>
> // not yet done.
>
>>       - snapshot destination will be subvol/.btrfs/snapshot@<time>  and
>
> snapshot destination is "/.snapshots/<number>/",
>
>>         snapshot/.btrfs/snapshot@<time>  for subvolume and snapshot
>>         respectively
>
> Timestamp and Description of a snapshot are stored in a small XML
> file /.snapshots/<number>/info.xml". One small file per snapshot.
>
> [...]
>
>>   Challenges:
>>     - rollback per file or dir instead of entire snapshot-rollback ?
>
> snapper implements  "rollback" on a FILE level only.
>
> To differentiate this way of "rolling back" from jumping
> into another snapshot, we call it
> 	"undochange"
> for now. This keeps the option to also manage a full
> per snapshot-rollback in a later point int time.
>
> [...]
>>       modify the snapshot - do we need to implement a kind of read-only
>>       snapshot ?
>
> snapper treats snapshots as read only snapshots, i.e. when doing a
> rollback - aehem, I should say "undochange" - only the "master" volume
> will be changed, not the single snapshots.  We are aware that this has
> pros and cons. But that's another discussion.
>
> I hope that this is a starting point for you.
>
> Enjoy "snapper".
>
> so long -
> 	MgE
>
