Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:36642 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaENQtR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 12:49:17 -0400
Message-ID: <53739F3E.3080509@libero.it>
Date: Wed, 14 May 2014 18:52:14 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: dsterba@suse.cz, Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, jshubin@redhat.com
Subject: Re: [PATCH V2] mkfs.btrfs: allow UUID specification at mkfs time
References: <5372C457.3000706@redhat.com> <53738D29.7020405@redhat.com> <20140514160133.GN6917@twin.jikos.cz>
In-Reply-To: <20140514160133.GN6917@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/14/2014 06:01 PM, David Sterba wrote:
> On Wed, May 14, 2014 at 10:35:05AM -0500, Eric Sandeen wrote:
>> > @@ -125,7 +154,19 @@ int make_btrfs(int fd, const char *device, const char *label,
>> >  	memset(&super, 0, sizeof(super));
>> >  
>> >  	num_bytes = (num_bytes / sectorsize) * sectorsize;
>> > -	uuid_generate(super.fsid);
>> > +	if (fs_uuid) {
>> > +		if (uuid_parse(fs_uuid, super.fsid) != 0) {
>> > +			fprintf(stderr, "could not parse UUID: %s\n", fs_uuid);
>> > +			ret = -EINVAL;
>> > +			goto out;
> I think the uuid validity check comes too late, IMHO it should be done
> after the while/getopt block outside of make_btrfs. At this point eg.
> the discard or device zeroing is already done.


Pay attention that, if you don't change the test_uuid_unique() you need to perform the check after zeroing the disk, or otherwise you are not able to mkfs the same disk with the same UUID (I suspect that this is a real use case for testing).

I am still convinced that a Warning is a better way to handle these kind of situations.

As reported before, forcing a unique UUID to be not unique is a thing to skilled person. The problem is that BTRFS in this regard behaves differently respect other file-systems, and even a skilled person could not be aware of the possible problem.
In this case is better to provide a complete information, instead of complicating the things adding further check.

BR
G.Baroncelli
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
