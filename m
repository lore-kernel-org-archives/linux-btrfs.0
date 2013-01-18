Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:42916 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab3ARQsq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Jan 2013 11:48:46 -0500
Received: from eastrmimpo109 ([68.230.241.222]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130118164846.SQSE17456.eastrmfepo201.cox.net@eastrmimpo109>
          for <linux-btrfs@vger.kernel.org>;
          Fri, 18 Jan 2013 11:48:46 -0500
Message-ID: <50F97CED.2040701@czarc.net>
Date: Fri, 18 Jan 2013 11:48:45 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, dsterba@suse.cz, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [GIT PULL] btrfs-progs: more bugfixes for 0.20-rc1
References: <20130117174721.GD22785@twin.jikos.cz> <50F95920.406@czarc.net> <20130118144439.GB19967@twin.jikos.cz> <50F96F00.3040008@czarc.net> <20130118155535.GB5406@carfax.org.uk>
In-Reply-To: <20130118155535.GB5406@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/18/2013 10:55 AM, Hugo Mills wrote:
> On Fri, Jan 18, 2013 at 10:49:20AM -0500, Gene Czarcinski wrote:
>> On 01/18/2013 09:44 AM, David Sterba wrote:
>>> On Fri, Jan 18, 2013 at 09:16:00AM -0500, Gene Czarcinski wrote:
>>>>> Sergei Trofimovich (1):
>>>>>        version.sh: fix version when built from tarball
>>>> While you are about it, how about adding in this fix from Dieter Ries to fix
>>>> version a little more:
>>>> http://article.gmane.org/gmane.comp.file-systems.btrfs/20069
>>> I did not notice it before, but Dieter's patch does not work when progs
>>> are built from .git repository
>>>
>>> -echo "#define BTRFS_BUILD_VERSION \"Btrfs $v\"" >> .build-version.h
>>> +echo "#define BTRFS_BUILD_VERSION \"$v\"" >> .build-version.h
>>>
>>> $v is set with the git tag, so the "Btrfs" string does not appear in the
>>> output (eg. mkfs.btrfs).
>>>
>>> Technically, $v should always contain some sort of a tag, Sergei's patch
>>> hardcodes it to the latest one for the non-git case. This is IMHO the
>>> right approach.
>>>
>> OK, I see what you mean.  However, the current situation when btrfs
>> is built from a tarball results in:
>>
>>> btrfs  --version
>> Btrfs Btrfs v0.19
>     I guess one problem here is that there's no canonical way of
> generating a tarball (without the git files) from a git checkout, with
> detailed version information. So what's happening, I suspect, is that
> the distributions/people producing source tarballs of btrfs-progs are
> checking out the git tree, deleting .git, and tarring up that, which
> loses any git versioning.
>
>     I think a solution may be to have a "dist" or "tar" make target
> which does the above automatically and includes a suitably-generated
> version.h in the tarball.
>
>     Hugo.
If you use gitweb to addess btrfs-progs.git, there is a very nice label 
"snapshot" beside each commit entry and clicking it will get you a 
tarball of the tree from that point.

I am a newbie at the git stuff but it seems to me that a few more 
branches are needed with stable branches marked as such and one or more 
unstable development branches ... at least that is what I have seen done 
on other projects such as NetworkManager and libvirt.  The branch will 
then include a hardcoded value for the version id which will/can be 
different in each branch.  And they also usually have a "make dist" 
which packages things up into a tarball.

The snapshot-tarball from gitweb includes the first part of the git 
commit id.  It is just that it is not included in a file.  The tarball 
does not includes only ".gitignore".  Rpms (and I assume the debian 
packages also) are based on tarball source with additional patches as 
necessary.  I have seen only one fedora package actually use git in the 
rpm and that was grub2.

While running stuff directly from a local git repository may be nice for 
developer, actual inclusion in a distribution package will (I believe) 
be via tarball.
>
>> and
>>
>>> mkfs.btrfs  -V
>> mkfs.btrfs, part of Btrfs Btrfs v0.19
>>
>> There must be a way to reliably just have one "Btrfs" and I will
>> look into it.
>>
As I was sitting here typing this message, the "solution" occurred to me:

Do not use Dieter's patch because it is unnecessary ... Sergei's patch 
does things correctly already.

Sorry for the noise on the list.  However, I do suggest that more git 
branches be used rather than having everything under "master".
