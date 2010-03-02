From: James Cloos <cloos@jhcloos.com>
Subject: Re: 2.6.33 high cpu usage
Date: Tue, 02 Mar 2010 15:12:59 -0500
Message-ID: <m3635e32jg.fsf@lugabout.jhcloos.org>
References: <m3hboy3726.fsf@lugabout.jhcloos.org>
	<20100302195322.GA3201@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100302195322.GA3201@localhost.localdomain> (Josef Bacik's
	message of "Tue, 2 Mar 2010 14:53:23 -0500")
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Josef" == Josef Bacik <josef@redhat.com> writes:

>> As you can see btrfs_find_space_cluster(), find_next_bit() and
>> find_next_zero_bit() use most of the sys cpu.  That patterns seems to
>> hold whenever I run perf top during such operations.

Josef> Ok well thats a bummer.  Would you mind trying this completely untested
Josef> and uncompiled patch :)?

It is compiling now.  I might not be able to reboot until tonight.  And
I'll want to do another incremental backup of the fs.  (I'm using it in
production in part because it only has mirrors, checkouts and the like
and because I have that backup.)

I'll reply again once I have results.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
