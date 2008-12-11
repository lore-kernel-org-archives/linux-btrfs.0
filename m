From: Oliver Mattos <oliver.mattos08@imperial.ac.uk>
Subject: Re: Data De-duplication
Date: Thu, 11 Dec 2008 03:42:58 +0000
Message-ID: <1228966979.7571.48.camel@mattos-laptop>
References: <1228862899.8130.1.camel@mattos-laptop>
	 <1228915802.11900.8.camel@think.oraclecorp.com>
	 <32809.2001:470:e828:1::2:2.1228939660.squirrel@avalon.arbitraryconstant.com>
	 <1228943437.7571.1.camel@mattos-laptop>
	 <20081210211903.GA29002@bludgeon.org>
	 <1228945336.7571.26.camel@mattos-laptop>
	 <20081210215754.GT23979@tracyreed.org>
	 <20081210221006.GA30484@bludgeon.org>
	 <1228954691.7571.33.camel@mattos-laptop>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Tracy Reed <treed@tracyreed.org>,
	<btrfs-devel@arbitraryconstant.com>,
	Chris Mason <chris.mason@oracle.com>
To: Ray Van Dolson <rayvd@bludgeon.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1228954691.7571.33.camel@mattos-laptop>
List-ID: <linux-btrfs.vger.kernel.org>

Here is a script to locate duplicate data WITHIN files:

On some test file sets of binary data with no duplicated files, about 3%
of the data blocks were duplicated, and about 0.1% of the data blocks
were nulls.  The data was mainly elf and win32 binaries plus some random
game data, office documents and a few images.

This code is hideously slow, so don't give it more than a couple of MB
of files to chew through at once.  In retrospect I should've just
written it in plain fast C instead of fighting with bash pipes!

Note to get "verbose" output, just remove everything after the word
"sort" in the code.

___________________  V  CODE  V  ____________________________

#!/bin/bash

# **********************************************************#
#                   Redunt data detector                    #
#                                                           #
# Simple Script to take an MD5 hash of every block in every #
# file in a folder and detect identical blocks              #
#                                                           #
# Copyright 2008 Oliver Mattos, Released under the GPL.     #
# **********************************************************#

#  WARNING - This script is very inefficient, so don't run it
#            with more than 50,000 blocks at once.

: ${1?"Usage: $0 PATH [BlockSize]"}

BS=${2-512}  #Block Size in bytes, can be specified on command line
NULLCOUNT="0"
DUPCOUNT="0"
TOTCOUNT="0"

NULLHASH=`dd if=/dev/zero bs=$BS count=1 2>/dev/null | md5sum -b`
NULLHASH="${NULLHASH:0:32}"

find "$1" | \
while read i; do
  if [ "` stat "$i" -c%f `" == "81a4" ]; then
    LEN=` stat "$i" -c%s `
    BC=0
    while [ $LEN -gt $[$BC * $BS] ]; do
      echo `dd if="$i" bs=$BS count=1 skip=$BC 2>/dev/null | md5sum -b`
$BC $i
      BC=$[ BC + 1 ]
    done
  fi;
done | sort | while read j; do
  OLDHASH=$HASH
  HASH=${j:0:32}
  TOTCOUNT=$[ $TOTCOUNT + 1 ]

  if [ "$HASH" == "$OLDHASH" ]; then
    DUPCOUNT=$[ DUPCOUNT + 1 ]
    if [ "$HASH" == "$NULLHASH" ]; then
      NULLCOUNT=$[ NULLCOUNT + 1 ]
    fi
  fi

  echo Hashed $TOTCOUNT $BS byte blocks, found $DUPCOUNT redundant \
       blocks of data, of which $NULLCOUNT blocks were null.
done | tail -n 1

# these last two lines are a bodge because the variables dont seem to
# come out of the while properly, probably something todo with the 
# pipes...


